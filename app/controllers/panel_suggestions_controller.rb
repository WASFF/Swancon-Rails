class PanelSuggestionsController < ApplicationController
	filter_resource_access	

  # GET /panel_suggestions
  # GET /panel_suggestions.xml
  def index
    @panel_suggestions = PanelSuggestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @panel_suggestions }
    end
  end

  # GET /panel_suggestions/1
  # GET /panel_suggestions/1.xml
  def show
    @panel_suggestion = PanelSuggestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @panel_suggestion }
    end
  end

  # GET /panel_suggestions/new
  # GET /panel_suggestions/new.xml
  def new
    @panel_suggestion = PanelSuggestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @panel_suggestion }
    end
  end

  # GET /panel_suggestions/1/edit
  def edit
    @panel_suggestion = PanelSuggestion.find(params[:id])
  end

  # POST /panel_suggestions
  # POST /panel_suggestions.xml
  def create
    @panel_suggestion = PanelSuggestion.new(params[:panel_suggestion])
		@panel_suggestion.user = current_user

    respond_to do |format|
      if @panel_suggestion.save
        format.html { redirect_to(@panel_suggestion, :notice => 'Panel suggestion was successfully created.') }
        format.xml  { render :xml => @panel_suggestion, :status => :created, :location => @panel_suggestion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @panel_suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /panel_suggestions/1
  # PUT /panel_suggestions/1.xml
  def update
    @panel_suggestion = PanelSuggestion.find(params[:id])

    respond_to do |format|
      if @panel_suggestion.update_attributes(params[:panel_suggestion])
        format.html { redirect_to(@panel_suggestion, :notice => 'Panel suggestion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @panel_suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /panel_suggestions/1
  # DELETE /panel_suggestions/1.xml
  def destroy
    @panel_suggestion = PanelSuggestion.find(params[:id])
    @panel_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to(panel_suggestions_url) }
      format.xml  { head :ok }
    end
  end
end
