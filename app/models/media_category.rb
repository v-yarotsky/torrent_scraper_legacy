class MediaCategory < ActiveRecord::Base
  has_many :tracker_categories
  has_many :torrents, :through => :tracker_categories
  validates_uniqueness_of :name

  def self.options_for_select
    MediaCategory.all.map { |c| [c.name, c.id] }.push ["New media category...", nil]
  end
end
