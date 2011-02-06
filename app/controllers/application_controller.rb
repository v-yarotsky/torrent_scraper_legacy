class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |login, password|
      login == "torrent" && password == "scraper"
    end
  end
end
