class Api::V1::StoreController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def purchase
    purchaser = User.find(params[:member_id])
    payment_type = PaymentType.find(params[:payment_type_id])
    order = UserOrder.new(
      payment_type: payment_type,
      operator: current_user,
      user: purchaser
    )
    user_tickets = []
    user_merchandise = []
    if params.has_key? :merchandise
      params[:merchandise].each do |junk, merch_data|
        merch_type = MerchandiseType.available(current_user).find(merch_data[:merchandise_type_id])
        merch_options = merch_type.options.where(id: merch_data[:merchandise_option_ids])
        user_merchandise << {type: merch_type, options: merch_options}
      end
    end
    if params.has_key? :tickets
      params[:tickets].each do |junk, ticket_data|
        ticket_type = TicketType.available(current_user).find(ticket_data[:ticket_type_id])
        user_tickets << {type: ticket_type, concession: ticket_data[:concession]}
      end
    end

    if user_tickets.empty? && user_merchandise.empty?
      render json: {error: "Nothing in cart..."}, status: :not_acceptable
      return
    end

    order.save
    user_tickets.each do |ticket_data|
      uot = UserOrderTicket.new(
        ticket_type: ticket_data[:type],
        concession: ticket_data[:concession],
        user_order: order,
        user: purchaser
      )
      uot.redeemed_at = DateTime.now if SiteSettings.con_mode
      uot.save
    end

    user_merchandise.each do |merch_data|
      uom = UserOrderMerchandise.new(
        merchandise_type: merch_data[:type],
        user_order: order
      )
      uom.save
      merch_data[:options].each do |option|
        uom.options << UserOrderMerchandiseOption.new(merchandise_option: option)
      end
    end

    data = {
      user_order_id: order.id,
      invoice_number: order.invoice_number,
      con_mode: SiteSettings.con_mode
    }

    if payment_type.requires_reconciliation
      if order.user.email_valid
        StoreMailer.invoice(order, current_user).deliver
        data[:email] = true
      else
        data[:email] = false
      end
      StoreMailer.confirmation_required(order, current_user).deliver
    else
      payment = Payment.create(
        user_order: order,
        payment_type: payment_type,
        operator: current_user,
        amount: order.total,
        verification_string: "Point Of Sale"
      )
      data[:payment_id] = payment.id
      data[:receipt_number] = payment.receipt
      if order.user.email_valid
        StoreMailer.receipt(payment, current_user).deliver
        data[:email] = true
      else
        data[:email] = false
      end      
    end

    render json: data
  end
end
