class Torrent < ActiveRecord::Base

  belongs_to :tracker_category
  has_one :tracker, :through => :tracker_category

  validates_presence_of :title, :link, :seeders
  validates_uniqueness_of :link
  validate :check_torrent

  @@seeders_limit = 5
  cattr_accessor :seeders_limit

  scope :for_tracker, ->(the_tracker) { joins(:tracker_category).where("tracker_categories.tracker_id = ?", the_tracker.id) }
  scope :for_category, ->(category) { joins(:tracker_category).where("tracker_categories.media_category_id = ?", category) }

  delegate :origin_url, :url, :to => :tracker, :prefix => true

  def check_torrent
    errors.add(:title, "is low-quality!") if title.present? and title =~ /camrip|telesynch/i
    errors.add(:seeders, "not enough!") if seeders.present? and seeders < @@seeders_limit
  end

  def new?
    created_at == Date.today and not downloaded
  end

  def download!
    tracker.get_scraper.download_torrent!(self)
    self.update_attributes(:downloaded => true)
  end

  def mark_as_deleted!
    self.deleted = true
    save!
  end


end
