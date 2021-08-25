# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Transaction < ApplicationRecord
  # == Constants ============================================================

  PENDING_STATUS = 'pending'
  SUCCESS_STATUS = 'success'
  FAIL_STATUS = 'failed'
  STATUSES = [PENDING_STATUS, SUCCESS_STATUS, FAIL_STATUS].freeze

  STATUSES.each do |status|
    scope status, -> { where status: status }
  end

  # TODO: fee payed by us
  scope :accountable_fee, -> { where from: %i[wallet deposit] }
  # TODO: blockchain normalize
  scope :by_address, ->(address) { where 'lower(from_address) = ? or lower(to_address) = ?', address.downcase, address.downcase }
  scope :by_to, ->(value) { where to: value }
  scope :by_from, ->(value) { where from: value }

  belongs_to :reference, polymorphic: true
  belongs_to :currency
  belongs_to :blockchain

  KINDS = %w[refill internal gas_refuel withdraw unauthorized_withdraw deposit collection unknown].freeze
  enum kind: KINDS

  ADDRESS_KINDS = { unknown: 1, wallet: 2, deposit: 3, absence: 4 }.freeze
  enum to: ADDRESS_KINDS, _prefix: true
  enum from: ADDRESS_KINDS, _prefix: true

  def self.ransackable_scopes(_auth_object = nil)
    %w[by_address accountable_fee by_to by_from]
  end

  def transaction_url
    blockchain&.explore_transaction_url txid
  end
end
