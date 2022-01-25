# frozen_string_literal: true

class MemberMakersTradesReport < Report
  def self.form_class
    MemberMakersTradesForm
  end

  def results
    super.sort_by { |_k, v| v }.reverse.to_h
  end

  class Generator < BaseGenerator
    def perform
      records.group(:market_id).count
    end

    def q
      q = {}
      q[:market_id_eq] = form.market_id if form.market_id.present?
      q[:created_at_gt] = form.time_from if form.time_from.present?
      q[:created_at_lteq] = form.time_to if form.time_to.present?
      q
    end

    def records
      Trade.user_maker_trades
           .ransack(q)
           .result
    end
  end
end
