class TrackersController < ApplicationController
  before_filter :initialize_tracker, :only => [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @trackers = Tracker.all
    respond_with @trackers
  end

  def show
    respond_with @tracker
  end

  def edit
    respond_with @tracker
  end

  def update
    if @tracker.update_attributes(params[:tracker])
      flash.now[:message] = "Tracker added successfully"
      redirect_to edit_tracker_path(@tracker)
    else
      flash.now[:message] = "Error adding tracker!"
      render :edit
    end
  end

  def new
    @tracker = Tracker.new
    respond_with @tracker
  end

  def create
    @tracker = Tracker.create(params[:tracker])
    respond_with @tracker
  end

  def destroy
    @tracker.destroy
    @trackers = Tracker.all
    render :index
  end

  def create_media_category
    return unless params[:new_media_category_name]
    MediaCategory.create(:name => params[:new_media_category_name])
    respond_to do |format|
      format.json { render :json => MediaCategory.options_for_select.to_json }
    end
  end

  protected

  def initialize_tracker
    @tracker = Tracker.find(params[:id])
  end

end
