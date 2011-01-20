class TrackersController < ApplicationController

  respond_to :html

  def index
    @trackers = Tracker.all
    respond_with @trackers
  end

  def show
    @tracker = Tracker.find(params[:id])
    respond_with @tracker
  end

  def edit
    @tracker = Tracker.find(params[:id])
    respond_with @tracker
  end

  def update
    @tracker = Tracker.find(params[:id])
    if @tracker.update_attributes(params[:tracker])
      flash.now[:message] = "Tracker added successfully"
    else
      flash.now[:message] = "Error adding tracker!"
    end
    Rails.logger.debug("Update tracker - valid: #{@tracker.valid?}")
    respond_with @tracker
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
    tracker = Tracker.find(params[:id])
    tracker.destroy
    @trackers = Tracker.all
  end

end
