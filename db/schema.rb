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

ActiveRecord::Schema.define(:version => 20130604042445) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "hashtag"
    t.text     "description"
    t.string   "background"
    t.date     "end"
    t.integer  "goal"
    t.string   "email_option", :default => "optional"
    t.string   "target",       :default => "house"
    t.text     "suggested",    :default => "[]"
    t.integer  "partner_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "campaigns", ["partner_id"], :name => "index_campaigns_on_partner_id"

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
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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
