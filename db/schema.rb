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

ActiveRecord::Schema.define(:version => 20130324074408) do

  create_table "award_categories", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description", :null => false
    t.integer  "award_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "award_nomination_categories", :force => true do |t|
    t.integer  "award_nomination_id", :null => false
    t.integer  "award_category_id",   :null => false
    t.string   "nominee",             :null => false
    t.string   "work",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "award_nominations", :force => true do |t|
    t.integer  "award_id",   :null => false
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "description",                    :null => false
    t.boolean  "active",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_blocks", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "bodytext"
    t.boolean  "autosummarize", :default => false, :null => false
    t.integer  "editor_id"
    t.integer  "author_id"
    t.integer  "tweet_id"
    t.string   "short_url"
    t.boolean  "preview",       :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  add_index "content_blocks", ["author_id"], :name => "index_content_blocks_on_author_id"
  add_index "content_blocks", ["editor_id"], :name => "index_content_blocks_on_editor_id"

  create_table "content_files", :force => true do |t|
    t.integer  "author_id"
    t.string   "description"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "data_fingerprint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_images", :force => true do |t|
    t.integer  "author_id"
    t.string   "description"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "data_fingerprint"
    t.text     "data_meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_pages", :force => true do |t|
    t.string   "name",                            :null => false
    t.integer  "content_block_id"
    t.integer  "content_tag_id"
    t.integer  "order_index",      :default => 0, :null => false
    t.boolean  "home"
    t.boolean  "navbar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "controller"
    t.string   "action"
  end

  create_table "content_tag_blocks", :force => true do |t|
    t.integer  "content_tag_id"
    t.integer  "content_block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "name_first",                           :null => false
    t.string   "name_last"
    t.string   "name_badge"
    t.string   "address_1",                            :null => false
    t.string   "address_2"
    t.string   "address_3",                            :null => false
    t.string   "address_postcode",                     :null => false
    t.string   "address_state",                        :null => false
    t.string   "address_country",                      :null => false
    t.string   "phone"
    t.boolean  "email_optin",       :default => false, :null => false
    t.boolean  "disclaimer_signed", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_images", :force => true do |t|
    t.integer  "merchandise_type_id"
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "image_height"
    t.integer  "image_width"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_option_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_options", :force => true do |t|
    t.string   "name"
    t.integer  "merchandise_type_id"
    t.integer  "merchandise_option_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "order_index",               :default => 0, :null => false
  end

  create_table "merchandise_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_types", :force => true do |t|
    t.string   "name"
    t.integer  "merchandise_set_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "available_from"
    t.datetime "available_to"
  end

  create_table "panel_suggestions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.boolean  "user_id_visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "user_email"
    t.boolean  "visible"
  end

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.boolean  "requires_reconciliation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available_online",           :default => false, :null => false
    t.float    "surcharge_percent"
    t.float    "surcharge_value"
    t.boolean  "available_to_ticket_seller", :default => false, :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "payment_type_id"
    t.float    "amount"
    t.boolean  "reconciled"
    t.string   "verification_string"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voiding_user_id"
    t.datetime "voided_at"
    t.integer  "operator_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "ticket_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "requires_extended_details", :default => false
  end

  create_table "ticket_types", :force => true do |t|
    t.string   "name"
    t.integer  "ticket_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "available_from"
    t.datetime "available_to"
    t.integer  "target",           :default => 0,   :null => false
    t.decimal  "concession_price"
    t.decimal  "price",            :default => 0.0, :null => false
  end

  create_table "user_omni_auths", :force => true do |t|
    t.string   "authtype"
    t.integer  "idvalue"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_omni_auths", ["authtype"], :name => "index_user_omni_auths_on_authtype"
  add_index "user_omni_auths", ["idvalue"], :name => "index_user_omni_auths_on_idvalue"
  add_index "user_omni_auths", ["user_id"], :name => "index_user_omni_auths_on_user_id"

  create_table "user_order_merchandise_options", :force => true do |t|
    t.integer  "user_order_merchandise_id"
    t.integer  "merchandise_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_order_merchandises", :force => true do |t|
    t.integer  "user_order_id"
    t.integer  "merchandise_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_order_id"
    t.datetime "arrived_at"
    t.datetime "shipped_at"
  end

  create_table "user_order_ticket_transfers", :force => true do |t|
    t.integer  "user_order_ticket_id", :null => false
    t.integer  "sender_id",            :null => false
    t.integer  "previous_owner_id",    :null => false
    t.integer  "recipient_id",         :null => false
    t.string   "confirmation_code"
    t.datetime "confirmed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_order_tickets", :force => true do |t|
    t.integer  "user_order_id"
    t.integer  "ticket_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "card_issued"
    t.datetime "arrived"
    t.boolean  "concession",     :default => false, :null => false
  end

  create_table "user_orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "payment_id"
    t.integer  "payment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.integer  "voided_by_id"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                              :null => false
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "vendor_orders", :force => true do |t|
    t.integer  "vendor_id",  :null => false
    t.datetime "placed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
