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
    else
      flash.now[:message] = "Error adding tracker!"
    end
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
    @tracker.destroy
    @trackers = Tracker.all
  end

  protected

  def initialize_tracker
    @tracker = Tracker.find(params[:id])
  end

end
