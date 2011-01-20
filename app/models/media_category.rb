class MediaCategory < ActiveRecord::Base
  has_many :tracker_categories
  has_many :torrents, :through => :tracker_categories
end
