class Api::V1::UserOrderTicketsController < ApplicationController
  respond_to :json

  def index
    if params.has_key? :member_id
      tickets = policy_scope(UserOrderTicket).where(user_id: params[:member_id].to_i).paid
      respond_with tickets
    else
      respond_with nil
    end
  end

  def update
    ticket = policy_scope(UserOrderTicket).find(params[:id])
    if ticket.present?
      ticket.update_attributes(update_params)
      ticket.save
    end
    respond_with ticket
  end

private
  def update_params
    params.require(:user_order_ticket).permit :redeemed_at
  end
end
