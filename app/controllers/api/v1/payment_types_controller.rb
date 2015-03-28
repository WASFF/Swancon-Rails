class Api::V1::PaymentTypesController < ApplicationController
  respond_to :json

  def index
    if SiteSettings.con_mode
      respond_with PaymentType.con_types
    else
      respond_with PaymentType.online_types
    end
  end
end
