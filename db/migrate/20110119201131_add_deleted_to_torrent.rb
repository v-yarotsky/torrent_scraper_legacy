class AddDeletedToTorrent < ActiveRecord::Migration
  def self.up
    add_column :torrents, :deleted, :boolean, :default => nil
  end

  def self.down
    remove_column :torrents, :deleted
  end
end
