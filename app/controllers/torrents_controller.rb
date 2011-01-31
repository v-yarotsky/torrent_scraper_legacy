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
    respond_to do |format|
      format.js do
        initialize_torrents
        Rails.logger.debug("*"*80)
        Rails.logger.debug(@torrents.order("torrents.#{params[:column]} #{params[:order]}").to_sql)
        Rails.logger.debug("*"*80)
      end
    end
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
