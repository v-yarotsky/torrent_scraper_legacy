# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

TorrentScraper::Application.load_tasks

task :checkout_torrents => :environment do
  Tracker.all.each { |tracker| tracker.get_scraper.checkout_torrents }
end

task :delete_torrents => :environment do
  Torrent.delete_all
end