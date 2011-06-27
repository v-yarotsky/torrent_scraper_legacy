class AddTrackerIdAndMediaCategoryIdToTorrents < ActiveRecord::Migration
  def self.up
    add_column :torrents, :tracker_id, :integer
    add_column :torrents, :media_category_id, :integer
    
    execute <<-SQL
      UPDATE torrents SET 
      torrents.tracker_id = (SELECT tracker_id FROM tracker_categories WHERE tracker_categories.id = torrents.tracker_category_id), 
      media_category_id = (SELECT media_category_id FROM tracker_categories WHERE tracker_categories.id = torrents.tracker_category_id);
    SQL
  end

  def self.down
    remove_column :torrents, :media_category_id
    remove_column :torrents, :tracker_id
  end
end