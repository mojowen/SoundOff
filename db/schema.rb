# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140213070052) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "hashtag"
    t.text     "description"
    t.string   "background"
    t.date     "end"
    t.integer  "goal"
    t.string   "email_option", :default => "optional"
    t.string   "status",       :default => "pending"
    t.string   "short_url"
    t.string   "target",       :default => "house"
    t.text     "suggested",    :default => "[]"
    t.integer  "partner_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "campaigns", ["partner_id"], :name => "index_campaigns_on_partner_id"
  add_index "campaigns", ["short_url"], :name => "index_campaigns_on_short_url", :unique => true

  create_table "hashtags", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hashtags", ["keyword"], :name => "index_hashtags_on_keyword"

  create_table "hashtags_statuses", :force => true do |t|
    t.integer "status_id",  :null => false
    t.integer "hashtag_id", :null => false
  end

  add_index "hashtags_statuses", ["hashtag_id", "status_id"], :name => "index_hashtags_statuses_on_hashtag_id_and_status_id"

  create_table "options", :force => true do |t|
    t.string "name"
    t.text   "data", :default => "", :null => false
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "tax_id"
    t.string   "partner_type"
    t.string   "logo"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "mailing_address"
    t.string   "privacy_policy"
    t.string   "twitter_screen_name"
    t.text     "twitter_data",        :default => "{}"
    t.string   "hear_about_soundoff"
    t.text     "custom_popup_css"
  end

  create_table "reps", :force => true do |t|
    t.string   "bioguide_id"
    t.string   "chamber"
    t.string   "district"
    t.string   "state"
    t.string   "state_name"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "party"
    t.string   "phone"
    t.string   "website"
    t.string   "contact_form"
    t.string   "twitter_screen_name"
    t.string   "twitter_id"
    t.string   "twitter_profile_image"
    t.text     "data",                  :default => "{}"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "reps", ["twitter_id"], :name => "index_reps_on_twitter_id"

  create_table "reps_statuses", :force => true do |t|
    t.integer "status_id", :null => false
    t.integer "rep_id",    :null => false
  end

  add_index "reps_statuses", ["rep_id", "status_id"], :name => "index_reps_statuses_on_rep_id_and_status_id"

  create_table "soundoffs", :force => true do |t|
    t.string   "zip"
    t.string   "email"
    t.string   "message"
    t.string   "targets"
    t.string   "hashtag"
    t.integer  "campaign_id"
    t.boolean  "headcount",           :default => false
    t.boolean  "partner",             :default => false
    t.string   "tweet_id"
    t.string   "twitter_screen_name"
    t.string   "tweet_data",          :default => "{}"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "soundoffs", ["campaign_id"], :name => "index_soundoffs_on_campaign_id"
  add_index "soundoffs", ["message"], :name => "index_soundoffs_on_message"

  create_table "statuses", :force => true do |t|
    t.string   "tweet_id"
    t.datetime "tweet_date"
    t.string   "screen_name"
    t.string   "user_id"
    t.string   "hashtags"
    t.string   "mentions"
    t.text     "message"
    t.integer  "soundoff_id"
    t.integer  "reply_to"
    t.text     "data",        :default => "{}"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "statuses", ["reply_to"], :name => "index_statuses_on_reply_to"
  add_index "statuses", ["soundoff_id"], :name => "index_statuses_on_soundoff_id"
  add_index "statuses", ["tweet_id"], :name => "index_statuses_on_tweet_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "partner_id"
    t.boolean  "admin",                  :default => false
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["partner_id"], :name => "index_users_on_partner_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
