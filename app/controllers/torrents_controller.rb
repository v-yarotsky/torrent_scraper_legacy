class TorrentsController < ApplicationController
  before_filter :initialize_torrent, :only => [:download, :destroy]
  before_filter :initialize_tracker_torrents, :only => [:sort, :search]

  def index
    initialize_torrents
  end

  def download
    @torrent.download!
    initialize_torrents
  end

  def sort
    respond_to do |format|
      format.js { render @torrents, :tracker => @tracker }
      format.html { render :index }
    end
  end

  def search
    respond_to do |format|
      format.js { render @torrents, :tracker => @tracker }
      format.html { render :index }
    end
  end

  def destroy
    @torrent.mark_as_deleted!
    initialize_torrents
    respond_to do |format|
      format.js
      format.html { render :index }
    end
  end

  protected

  def initialize_torrent
    @torrent = Torrent.find_by_id(params[:id])
  end

  def initialize_torrents
    @torrents = Filter.instance.filter(Torrent.scoped, { "date" => "today", "state" => "pending" }.merge(params))
  end

  def initialize_tracker_torrents
    media_category = MediaCategory.find_by_id(params[:media_category_id])
    @tracker = Tracker.find_by_id(params[:tracker_id])
    @torrents = initialize_torrents.for_tracker(@tracker).for_category(media_category)
    unless params[:column].blank? or params[:order].blank?
      @torrents = @torrents.order("torrents.#{params[:column]} #{params[:order]}")
    end
    params[:search].reject {|k, v| v.blank? }.each do |column, value|
      @torrents = @torrents.where("torrents.#{column} LIKE ?", "%#{value}%")
    end if params[:search]
  end

end
