class Tracker < ActiveRecord::Base

  has_many :tracker_categories, :dependent => :destroy
  has_many :media_categories, :through => :tracker_categories, :uniq => true
  has_many :torrents, :through => :tracker_categories

  accepts_nested_attributes_for :tracker_categories, :allow_destroy => true

  def get_scraper
    scraper_name = self.name.split(/[.-]/).map(&:capitalize).join + "Scraper"
    scraper_class = self.class.const_get(scraper_name)
    scraper = scraper_class.new
    scraper
  end

  def origin_url
    self.url[/(?!\/)http:\/\/\w+\.\w+/]
  end

end
