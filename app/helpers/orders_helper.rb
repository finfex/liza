# frozen_string_literal: true

module OrdersHelper
  def present_order(order)
    case order
    when OrderBid
      present_order_bid(order)
    when OrderAsk
      present_order_ask(order)
    else
      raise "Unknown order type #{order}"
    end
  end

  def present_order_bid(order)
    link_to order_path(order), target: '_blank' do
      ('order bid<br>' + format_money(order.price,
                                      order.currency,
                                      show_currency: true,
                                      tooltip: "order_id:#{order.id}")).html_safe
    end
  end

  def present_order_ask(order)
    link_to order_path(order), target: '_blank' do
      ('order ask<br>' + format_money(order.price,
                                      order.currency,
                                      show_currency: true,
                                      tooltip: "order_id:#{order.id}")).html_safe
    end
  end
end
