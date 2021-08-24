# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# TODO: Rename to DepositAddress
class PaymentAddress < ApplicationRecord
  extend PaymentAddressTotals

  belongs_to :member
  belongs_to :blockchain
  has_many :currencies, through: :blockchain

  delegate :native_currency, to: :blockchain

  scope :currency_id_eq, ->(currency_id) { joins(:currencies).where(currencies: { id: currency_id } ) }

  def self.ransackable_scopes(auth_object = nil)
    %w(currency_id_eq)
  end

  def format_address(format)
    format == 'legacy' ? to_legacy_address : to_cash_address
  end

  def to_legacy_address
    CashAddr::Converter.to_legacy_address(address)
  end

  def to_cash_address
    CashAddr::Converter.to_cash_address(address)
  end

  def address_url
    blockchain&.explore_address_url address
  end

  def transactions
    if address.nil?
      []
    else
      # TODO blockchain normalize
      blockchain&.transactions.by_address(address.downcase)
    end
  end
end
