class TicketsController < ApplicationController
	filter_access_to :all

	def index
		@alltickets = false
		@sets = Array.new
		if params[:all] == "true" and current_user.role_symbols.include?(:admin)
			@alltickets = true
			TicketSet.all.each do |set|
				if set.sold_tickets.count > 0 
					@sets << {set: set, tickets: set.sold_tickets }
				end
			end
		else
			TicketSet.all.each do |set|
				if set.sold_tickets.where(user_id: current_user.id).count > 0
					@sets << {set: set, tickets: set.sold_tickets.where(user_id: current_user.id) }
				end
			end
		end
	end

	def find_user
		@user = User.joins(:member_detail).where(email: params[:email]).first
	end

	def transfer
		@user_order_ticket = UserOrderTicket.where(id: params[:id].to_i).first
		if @user_order_ticket != nil and @user_order_ticket.can_transfer?(current_user)
			return
		elsif @user_order_ticket != nil
			flash[:alert] = "You can't transfer this ticket."
		else
			flash[:alert] = "Could not find ticket."
		end
		redirect_to action: :index, all: params[:alltickets]
	end

	def confirm_transfer
		user_order_ticket = UserOrderTicket.where(id: params[:id].to_i).first
		if user_order_ticket != nil and user_order_ticket.can_transfer?(current_user)
			recipient = User.where(id: params[:recipient_id]).first
			if recipient != nil
				transfer = user_order_ticket.transfer(current_user, recipient)
				if current_user.role_symbols.include?(:admin)
					flash[:alert] = "Transfer Completed."
					transfer.confirm
				else
					# SEND EMAIL IF NON ADMIN.
					flash[:alert] = "Transfer Initiated - you will have the reconfirmation email."
					TransferMailer.reconfirm_sender(transfer).deliver
					TransferMailer.reconfirm_recipient(transfer).deliver
					TransferMailer.reconfirm_admin(transfer).deliver
				end
			else
				flash[:alert] = "This recipient doesn't exist?"
			end
		elsif user_order_ticket != nil
			flash[:alert] = "You can't transfer this ticket."
		else
			flash[:alert] = "Could not find ticket."
		end
		redirect_to action: :index, all: params[:alltickets]
	end

	def reconfirm_transfer
		transfer = UserOrderTicketTransfer.where(id: params[:id]).where(confirmed_on: nil).first
		if (transfer == nil)
			flash[:alert] = "Could not find transfer."
		elsif (transfer.confirmation_code == params[:code])
			if transfer.ticket.can_transfer?(current_user)
				TransferMailer.completed_sender(transfer).deliver
				TransferMailer.completed_recipient(transfer).deliver
				TransferMailer.completed_admin(transfer).deliver
				flash[:alert] = "Transfer completed!"
				transfer.confirm
			elsif current_user == nil
				flash[:alert] = "You must log in to confirm the transfer"
			else
				flash[:alert] = "You cannot transfer this transfer"
			end
		end
		redirect_to action: :index
	end

	def cancel_transfer
		transfer = UserOrderTicketTransfer.where(id: params[:id]).where(confirmed_on: nil).first
		if (transfer == nil)
			flash[:alert] = "Could not find transfer."
		elsif (transfer.confirmation_code == params[:code])
			if transfer.can_cancel?(current_user) and transfer.confirmed_on == nil
				flash[:alert] = "Transfer cancelled!"
				TransferMailer.cancel_sender(transfer).deliver
				TransferMailer.cancel_recipient(transfer).deliver
				TransferMailer.cancel_admin(transfer).deliver				
				transfer.destroy
			elsif current_user == nil
				flash[:alert] = "You must log in to cancel the transfer"
			elsif transfer.confirmed_on != nil
				flash[:alert] = "This transfer has already been confirmed"
			else
				flash[:alert] = "You cannot cancel this transfer"
			end

		end
		redirect_to action: :index
	end	
end
