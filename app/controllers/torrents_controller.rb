class TorrentsController < ApplicationController
  before_filter :initialize_torrent, :only => [:download, :destroy]

  def index
    initialize_torrents
  end

  def download
    @torrent.download!
    initialize_torrents
  end

  def sort
    media_category = MediaCategory.find_by_id(params[:media_category_id])
    tracker = Tracker.find_by_id(params[:tracker_id])
    @torrents = initialize_torrents.for_tracker(tracker).for_category(media_category).order("torrents.#{params[:column]} #{params[:order]}")
    render :partial => "torrents/sort", :locals => params.merge(:tracker => tracker, :media_category => media_category)
  end

  def destroy
    @torrent.mark_as_deleted!
    initialize_torrents
  end

  protected

  def initialize_torrent
    @torrent = Torrent.find_by_id(params[:id])
  end

  def initialize_torrents
    @torrents = Filter.instance.filter(Torrent.scoped, { "date" => "today", "state" => "pending" }.merge(params))
  end

end
