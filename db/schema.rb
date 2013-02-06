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

ActiveRecord::Schema.define(:version => 20130206102600) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id",                   :null => false
    t.string   "auditable_type",                 :null => false
    t.integer  "owner_id",                       :null => false
    t.string   "owner_type",                     :null => false
    t.integer  "user_id",                        :null => false
    t.string   "user_type",                      :null => false
    t.string   "action",                         :null => false
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.text     "comment"
    t.datetime "created_at",                     :null => false
  end

  add_index "audits", ["auditable_id", "auditable_type", "version"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "event_charges", :force => true do |t|
    t.string   "name"
    t.integer  "price_cents",    :default => 0,     :null => false
    t.string   "price_currency", :default => "USD", :null => false
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "bill"
  end

  add_index "event_charges", ["event_id"], :name => "index_event_charges_on_event_id"
  add_index "event_charges", ["user_id"], :name => "index_event_charges_on_user_id"

  create_table "event_comments", :force => true do |t|
    t.text     "text"
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_compensations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_participations", ["event_id"], :name => "index_event_participations_on_event_id"
  add_index "event_participations", ["user_id"], :name => "index_event_participations_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "owner"
    t.boolean  "closed",         :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "trashed",        :default => false
    t.datetime "trashed_at"
    t.boolean  "compensated",    :default => false
    t.datetime "compensated_at"
    t.datetime "closed_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",                  :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.text     "description"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "locale",                 :limit => 5
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
