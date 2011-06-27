class TrackerCategory < ActiveRecord::Base
  belongs_to :tracker
  belongs_to :media_category
  has_many :torrents

  attr_accessor :new_media_category_name

  before_save -> { 
    create_media_category_from_name; 
    if media_category_id_changed?
      ActiveRecord::Base.connection.execute("UPDATE torrents SET media_category_id = #{media_category_id} WHERE torrents.tracker_category_id = #{id}")
    end
  }

  delegate :name, :to => :media_category, :prefix => true

  validates_presence_of :name_on_tracker
  validates_numericality_of :min_seeders
  validates_associated :media_category
  default_scope order("created_at ASC")
  protected

  def create_media_category_from_name
    create_media_category(:name => new_media_category_name) unless new_media_category_name.blank?
  end

end
