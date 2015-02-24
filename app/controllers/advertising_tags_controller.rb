class AdvertisingTagsController < ApplicationController
  before_filter :load_resource, except: [:index, :new, :create]

  def index
    authorize AdvertisingTag, :index?
    @tags = AdvertisingTag.all.order(:name)
  end

  def show
    authorize @tag, :show?
  end

  def new
    authorize AdvertisingTag, :create?
    @tag = AdvertisingTag.new
  end

  def create
    authorize AdvertisingTag, :create?
    @tag = AdvertisingTag.new(tag_params)
    if @tag.save
      flash[:notice] = 'Advertising Tag was successfully created.'
      redirect_to @tag
    else
      render :new
    end
  end

  def edit
    redirect_to action: :index unless user_can? :edit?, @tag
    @title = "Editing Tag #{@tag.name}"
  end

  def update
    redirect_to action: :index unless user_can? :edit?, @tag
    if @tag.update_attributes(tag_params)
      flash[:notice] = 'Advertising Tag was successfully updated.'
      redirect_to @tag
    else
      render :edit
    end
  end

  def destroy
    authorize @tag, :destroy?
    @tag.destroy
    redirect_to advertising_tags_path
  end

private
  def tag_params
    params.require(:advertising_tag).permit(
      :name, :funnel_name, :tracking_code
    )
  end

  def load_resource
    @tag = AdvertisingTag.find_by_id(params[:id])
  end

end
