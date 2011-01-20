class TrackerCategory < ActiveRecord::Base
  belongs_to :tracker
  belongs_to :media_category
  has_many :torrents

  attr_accessor :new_media_category_name

  before_save -> { create_media_category_from_name }

  protected

  def create_media_category_from_name
    create_media_category(:name => new_media_category_name) unless new_media_category_name.blank?
  end

end
