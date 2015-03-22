class Api::V1::MembersController < ApplicationController
  respond_to :json

  def index
    if params.has_key? :name
      @users = policy_scope(User).search_for_name(params[:name])
      respond_with @users, include_member_details: true
    else
      respond_with nil
    end
  end

  def show
    authorize @tag, :show?
    respond_with @tag
  end

  def create
  end

  def update
  end

  def destroy
  end

private
  def create_params
    params.require(:event).permit(:name, :start_date, :start_time, :end_date, :end_time, :timezone)
  end
end
