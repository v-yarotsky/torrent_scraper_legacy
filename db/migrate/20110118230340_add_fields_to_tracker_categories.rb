class AddFieldsToTrackerCategories < ActiveRecord::Migration
  def self.up
    add_column :tracker_categories, :disallowed_keywords, :string, :default => ""
    add_column :tracker_categories, :allowed_keywords, :string, :default => ""
    add_column :tracker_categories, :min_seeders, :integer, :default => 50
  end

  def self.down
    remove_column :tracker_categories, :disallowed_keywords
    remove_column :tracker_categories, :allowed_keywords
    remove_column :tracker_categories, :min_seeders
  end
end
