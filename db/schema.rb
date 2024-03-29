# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110627203151) do

  create_table "media_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "torrents", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "seeders"
    t.integer  "size"
    t.string   "tracker_link"
    t.boolean  "downloaded"
    t.integer  "tracker_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted"
    t.integer  "tracker_id"
    t.integer  "media_category_id"
  end

  create_table "tracker_categories", :force => true do |t|
    t.integer  "tracker_id"
    t.integer  "media_category_id"
    t.string   "name_on_tracker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "disallowed_keywords", :default => ""
    t.string   "allowed_keywords",    :default => ""
    t.integer  "min_seeders",         :default => 50
  end

  create_table "trackers", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
