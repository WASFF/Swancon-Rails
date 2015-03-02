class EventsController < ApplicationController
  before_filter :load_resource, except: [:index, :new, :create]

  def index
    unless user_can? :index?, Event
      redirect_to root_url
    end
    @events = Event.order("start_time desc")
    @title = "Showing Events"
  end

  def show
    redirect_to action: :index unless user_can? :see?, @event
    @title = "Showing Event #{@event.title}"
  end

  def new
    redirect_to action: :index unless user_can? :edit?, Event

    @event = Event.new
    @event.content_block = ContentBlock.new
    @title = "Create Event"
  end

  def create
    redirect_to action: :index unless user_can? :edit?, Event
    @event = Event.new(events_params)
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        redirect_to @event
      else
        render :new
      end    
  end

  def edit
    redirect_to action: :index unless user_can? :edit?, @event
    @title = "Editing event #{@event.title}"
  end

  def view
    @title = @event.title
  end

  def update
    redirect_to action: :index unless user_can? :edit?, @event
    update_params = events_params
    block_attributes = update_params.delete(:content_block_attributes)
    if @event.update_attributes(update_params) && @event.content_block.update_attributes(block_attributes)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    redirect_to action: :index unless user_can? :destroy?, @event
    @event.destroy
    redirect_to events_path
  end

private
  def load_resource
    @event = Event.find_by_id(params[:id])
  end

  def events_params
    params.require(:event).permit(
      {content_block_attributes: [
        :title, :content_image_id, :preview, :autosummarize, :bodytext, :summary
      ]}, :start_time_parsed, :end_time_parsed
    )
  end


end
