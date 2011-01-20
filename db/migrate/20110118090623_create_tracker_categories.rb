class CreateTrackerCategories < ActiveRecord::Migration
  def self.up
    create_table :tracker_categories do |t|
      t.integer :tracker_id
      t.integer :media_category_id
      t.string :name_on_tracker

      t.timestamps
    end
  end

  def self.down
    drop_table :tracker_categories
  end
end
