class TorrentsController < ApplicationController

  def index
    @trackers = Tracker.scoped
  end

  def show
  end

  def download
    @torrent = Torrent.find(params[:id])
    @torrent.download!
    @trackers = Tracker.scoped
  end

  def destroy
    torrent = Torrent.find(params[:id])
    torrent.mark_as_deleted! if torrent
    @trackers = Tracker.scoped
  end

end
