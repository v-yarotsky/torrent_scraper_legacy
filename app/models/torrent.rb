class Torrent < ActiveRecord::Base

  belongs_to :tracker_category
  has_one :tracker, :through => :tracker_category

  validates_presence_of :title, :link, :seeders
  validates_uniqueness_of :link
  validate :check_torrent

  @@seeders_limit = 5
  cattr_accessor :seeders_limit

  scope :for_tracker, ->(tracker) { tracker.blank? ? scoped : joins(:tracker_category).where("tracker_categories.tracker_id = ?", tracker.to_param) }
  scope :for_category, ->(category) { category.blank? ? scoped : joins(:tracker_category).where("tracker_categories.media_category_id = ?", category.to_param) }
  
  scope :search, lambda { |terms|    
    return scoped unless terms
    relation = scoped.clone
    terms.reject {|k, v| v.blank? }.each do |column, value|
      relation &= where("torrents.#{column} LIKE ?", "%#{value}%")
    end
    relation
  }

  scope :ordered, lambda { |column, order|
    return scoped if column.blank? or order.blank?
    order("torrents.#{column} #{order}")
  }

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
