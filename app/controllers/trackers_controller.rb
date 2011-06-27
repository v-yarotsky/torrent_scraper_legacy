class TrackersController < ApplicationController
  respond_to :html

  def index
  end

  def show
  end

  def edit
  end

  def update
    if tracker.update_attributes(params[:tracker])
      flash.now[:message] = "Tracker added successfully"
      redirect_to edit_tracker_path(tracker)
    else
      flash.now[:message] = "Error adding tracker!"
      render :edit
    end
  end

  def new
    @tracker = Tracker.new
  end

  def create
    @tracker = Tracker.create(params[:tracker])
    respond_with tracker
  end

  def destroy
    tracker.destroy
    render :action => :index
  end

  def create_media_category
    return unless params[:new_media_category_name]
    MediaCategory.create(:name => params[:new_media_category_name])
    respond_to do |format|
      format.json { render :json => MediaCategory.options_for_select.to_json }
    end
  end

  private

  def tracker
    @tracker ||= Tracker.find(params[:id])
  end
  helper_method :tracker
  
  def trackers
    @trackers ||= Tracker.all
  end
  helper_method :trackers

end
