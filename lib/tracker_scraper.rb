#encoding: utf-8
require 'mechanize'
module TrackerScraper

  def initialize
    tracker_name = self.class.name.gsub(/Scraper/,'').underscore.gsub('_','.').capitalize

    Rails.logger.info("--------------------Tracker name: #{tracker_name}--------------------")

    @tracker = Tracker.find_by_name(tracker_name)
    raise ArgumentError.new("Tracker does not exist!") if @tracker.blank?
    @agent = Mechanize.new
  end

  def process(&block)
    visit_tracker
    begin
      login
      block.call(self) if block_given?
    rescue Exception => e
      Rails.logger.error(e.message)
    ensure
      logout
    end
  end

  def visit_tracker
    @agent.get(:url => @tracker.url, :headers => { 'Accept-Charset' => 'utf-8' })
    Rails.logger.warn("Encountered following parse errors:\n\t#{@agent.page.parser.errors.map(&:to_s).join(";\n\t")}")
  end

  def login
  end

  def logout
  end

  def set_options
  end

  def fetch_torrents
  end

  def checkout_torrents
    visit_tracker
    login
    set_options
    fetch_torrents
    logout
  end

  def check_torrent(torrent_attributes)
    category = torrent_attributes[:tracker_category]
    title = torrent_attributes[:title]
    return false if torrent_attributes[:seeders] < category.min_seeders
    required_keywords = category.allowed_keywords.split(/;/).map(&:strip).join("|")
    return false unless title =~ /#{required_keywords}/i
    disallowed_keywords = category.disallowed_keywords.split(/;/).map(&:strip).join("|")
    return false if disallowed_keywords.present? and title =~ /#{disallowed_keywords}/i
    true
  end

  def download_torrent!(torrent)
    filename = ""
    process do
      dir = File.join(Rails.root, 'public', 'torrents')
      FileUtils.mkdir_p(dir)
      torrent_file = @agent.get(torrent.link)
      filename = "#{dir}/#{torrent_file.filename.gsub /^"|"$/, ''}"
      torrent_file.save_as(filename)
    end
    Rails.logger.info("Torrent downloaded to: #{filename}")
    filename
  end

  def page
    @agent.page
  end

end
