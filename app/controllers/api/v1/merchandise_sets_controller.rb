class Api::V1::MerchandiseSetsController < ApplicationController
  respond_to :json

  def index
    respond_with MerchandiseSet.available(current_user), full_tree: true
  end
end
