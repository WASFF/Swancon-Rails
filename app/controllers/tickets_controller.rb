class TicketsController < ApplicationController
	filter_access_to :all

	def index
		@all = true
		@multiple = false
		@pending = false
		@cards = false
		@sets = TicketSet.all
		@subquery = nil
		if params[:multiple] == "true"
			@all = false
			@multiple = true
			@subquery = :user_owns_multiple
		elsif params[:pending] == "true"
			@all = false
			@pending = true
			@subquery = :pending
		elsif params[:cards] == "true"
			@all = false
			@cards = true
			@subquery = :cards_unsent
		end
	end

	def export
		@all = true
		@multiple = false
		@pending = false
		@cards = false
		set = TicketSet.find(params[:id])
		@filename = "#{set.name.downcase.gsub(" ", "_")}"
		if params[:multiple] == "true"
			@all = false
			@multiple = true
			@tickets = set.user_owns_multiple
			@filename += "-owners_of_multiple_tickets"
		elsif params[:pending] == "true"
			@all = false
			@pending = true
			@tickets = set.pending
			@filename += "-pending_transfers"
		elsif params[:cards] == "true"
			@all = false
			@cards = true
			@tickets = set.cards_unsent
			@filename += "-cards_unsent"
		else
			@tickets = set.sold_tickets
		end

		@filename += "-all_details.csv"

		headers.merge!({
			'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
			'Content-Type' => 'text/csv',
			'Content-Transfer-Encoding' => 'binary'
		})
	end

	def export_badges
		@all = true
		@multiple = false
		@pending = false
		@cards = false
		set = TicketSet.find(params[:id])
		@filename = "#{set.name.downcase.gsub(" ", "_")}"
		if params[:multiple] == "true"
			@all = false
			@multiple = true
			@tickets = set.user_owns_multiple
			@filename += "-owners_of_multiple_tickets"
		elsif params[:pending] == "true"
			@all = false
			@pending = true
			@tickets = set.pending
			@filename += "-pending_transfers"
		elsif params[:cards] == "true"
			@all = false
			@cards = true
			@tickets = set.cards_unsent
			@filename += "-cards_unsent"
		else
			@tickets = set.sold_tickets
		end

		@filename += ".csv"

		headers.merge!({
			'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
			'Content-Type' => 'text/csv',
			'Content-Transfer-Encoding' => 'binary'
		})
	end

	def export_salesdata
		export_badges
	end

	def my
		@sets = current_user.owned_ticket_sets
	end

	def find_user
		@user = User.joins(:member_detail).where(email: params[:email].strip).first
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
				transfer = user_order_ticket.transfer(current_user, recipient) and !user_order_ticket.transferring
				if current_user.role_symbols.include?(:admin)
					flash[:alert] = "Transfer Completed."
					TransferMailer.completed_sender(transfer).deliver
					TransferMailer.completed_recipient(transfer).deliver
					TransferMailer.completed_admin(transfer).deliver
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

	def card_issue
		@ticket = UserOrderTicket.where(:id => params[:id]).first
		@ticket.issue_card
		render action: "ticket_reload"
	end

	def card_unissue
		@ticket = UserOrderTicket.where(:id => params[:id]).first
		@ticket.unissue_card
		render action: "ticket_reload"
	end
end
