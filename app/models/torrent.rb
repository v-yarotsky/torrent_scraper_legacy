class Torrent < ActiveRecord::Base

  belongs_to :tracker_category
  has_one :tracker, :through => :tracker_category

  validates_presence_of :title, :link, :seeders
  validates_uniqueness_of :link
  validate :check_torrent

  @@seeders_limit = 5
  cattr_accessor :seeders_limit

  scope :fresh, where("torrents.updated_at > ?", Time.now.utc.beginning_of_day)
  scope :for_tracker, ->(the_tracker) { joins(:tracker_category).where("tracker_categories.tracker_id = ?", the_tracker.id) }
  scope :pending, where("download IS NULL")

  default_scope where("deleted IS NULL")

  def check_torrent
    errors.add(:title, "is low-quality!") if title.present? and title =~ /camrip|telesynch/i
    errors.add(:seeders, "not enough!") if seeders.present? and seeders < @@seeders_limit
  end

  def new?
    created_at == Date.today and not download
  end

  def download!
    tracker.get_scraper.download_torrent!(self)
    mark_as_deleted!
  end

  def mark_as_deleted!
    self.deleted = true
    save!
  end


end
