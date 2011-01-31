class TorrentsController < ApplicationController
  before_filter :initialize_torrent, :only => [:download, :destroy]

  def index
    initialize_torrents
  end

  def download
    @torrent.download!
    initialize_torrents
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
    @torrents = Filter.instance.filter(Torrent.scoped, params || { "date" => "today", "state" => "pending" })
    Rails.logger.debug("TORRENTS: #{@torrents.inspect}")
  end

end
