class CreateTorrents < ActiveRecord::Migration
  def self.up
    create_table :torrents do |t|
      t.string :title
      t.string :link
      t.integer :seeders
      t.integer :size
      t.string :tracker_link
      t.boolean :downloaded
      t.integer :tracker_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :torrents
  end
end
