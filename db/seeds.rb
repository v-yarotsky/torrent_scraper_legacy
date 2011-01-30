#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
torrents_by = Tracker.create(:name => "Torrents.by",
                            :url => "http://torrents.by/forum/index.php")

rutracker_org = Tracker.create(:name => "Rutracker.org",
                               :url => "http://rutracker.org/forum/index.php")

media_categories = []
%W(Кино Сериалы).each do |name|
  media_categories << MediaCategory.new(:name => name)
end

[
  { :media_category => media_categories[0], :name_on_tracker => "DVDRip (DVDScreener, SATRip, TVRip, VHSRip)",      :allowed_keywords => "",            :disallowed_keywords => "camrip;telesynch", :min_seeders => 5 },
  { :media_category => media_categories[0], :name_on_tracker => "BDRip и HDRip",                                    :allowed_keywords => "",            :disallowed_keywords => "",                 :min_seeders => 5 },
  { :media_category => media_categories[1], :name_on_tracker => "Интерны",                                          :allowed_keywords => "",            :disallowed_keywords => "",                 :min_seeders => 50},
  { :media_category => media_categories[1], :name_on_tracker => "Сверхъестественное / Supernatural",                :allowed_keywords => "",            :disallowed_keywords => "",                 :min_seeders => 50},
  { :media_category => media_categories[1], :name_on_tracker => "Доктор Хаус / House M.D.",                         :allowed_keywords => "lostfilm",    :disallowed_keywords => "",                 :min_seeders => 50},
  { :media_category => media_categories[1], :name_on_tracker => "Как я встретил вашу маму / How I Met Your Mother", :allowed_keywords => "Кураж;Kuraj", :disallowed_keywords => "",                 :min_seeders => 50},
  { :media_category => media_categories[1], :name_on_tracker => "Теория Большого Взрыва / The Big Bang Theory",     :allowed_keywords => "Кураж;Kuraj", :disallowed_keywords => "",                 :min_seeders => 50},
].each do |attributes|
  torrents_by.tracker_categories.create(attributes)
end

[
  { :media_category => media_categories[0], :name_on_tracker => "Фильмы 2010-2011",   :allowed_keywords => "",                :disallowed_keywords => "camrip;telesynch", :min_seeders => 50 },
  { :media_category => media_categories[0], :name_on_tracker => "Наше кино",          :allowed_keywords => "",                :disallowed_keywords => "camrip;telesynch", :min_seeders => 50 },
  { :media_category => media_categories[1], :name_on_tracker => "Зарубежные сериалы", :allowed_keywords => "community;event", :disallowed_keywords => "",                 :min_seeders => 10 }
].each do |attributes|
  rutracker_org.tracker_categories.create(attributes)
end



