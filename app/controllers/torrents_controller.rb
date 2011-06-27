class TorrentsController < ApplicationController
  DEFAULT_FILTER = { "date" => "today", "state" => "pending" }

  def index
  end

  def download
    torrent.download!
  end

  def sort
    respond_to do |format|
      format.js { render torrents }
      format.html { render :index }
    end
  end

  def search
    respond_to do |format|
      format.js { render torrents }
      format.html { render :index }
    end
  end

  def destroy
    torrent.mark_as_deleted!
    respond_to do |format|
      format.js
      format.html { render :index }
    end
  end

  private
  
  def torrent
    @torrent ||= Torrent.find_by_id(params[:id])
  end
  helper_method :torrent

  def torrents
    return @torrents if defined? @torrents
    torrents = Torrent.for_tracker(params[:tracker_id]).for_category(params[:media_category_id]).search(params[:search]).ordered(params[:column], params[:order])
    @torrents = Filter.instance.filter(torrents, DEFAULT_FILTER.merge(params))
    @torrents
  end
  helper_method :torrents
  
end
