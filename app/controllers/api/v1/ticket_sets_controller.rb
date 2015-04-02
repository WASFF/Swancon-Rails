class Api::V1::TicketSetsController < ApplicationController
  respond_to :json

  def index
    respond_with TicketSet.available(current_user), full_tree: true
  end
end
