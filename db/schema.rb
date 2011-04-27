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

ActiveRecord::Schema.define(:version => 201103230827024) do

  create_table "content_blocks", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "bodytext"
    t.boolean  "autosummarize", :default => false, :null => false
    t.integer  "editor_id"
    t.integer  "author_id"
    t.boolean  "published",     :default => false, :null => false
    t.integer  "tweet_id"
    t.string   "short_url"
    t.boolean  "preview",       :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_blocks", ["author_id"], :name => "index_content_blocks_on_author_id"
  add_index "content_blocks", ["editor_id"], :name => "index_content_blocks_on_editor_id"

  create_table "content_pages", :force => true do |t|
    t.string   "name",             :null => false
    t.integer  "content_block_id"
    t.integer  "content_tag_id"
    t.integer  "order_index"
    t.boolean  "home"
    t.boolean  "navbar"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "launch_member_merchandise_types", :force => true do |t|
    t.integer  "launch_member_id"
    t.integer  "merchandise_type_id"
    t.string   "merchandise_options_hash"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "launch_member_ticket_types", :force => true do |t|
    t.integer  "launch_member_id"
    t.integer  "ticket_type_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "launch_members", :force => true do |t|
    t.string   "name_first",                           :null => false
    t.string   "name_last"
    t.string   "name_badge"
    t.string   "address_street1",                      :null => false
    t.string   "address_street2"
    t.string   "address_street3",                      :null => false
    t.string   "address_postcode",                     :null => false
    t.string   "address_state",                        :null => false
    t.string   "address_country",                      :null => false
    t.string   "phoneno"
    t.string   "email"
    t.boolean  "email_optin",       :default => false, :null => false
    t.boolean  "disclaimer_signed", :default => false, :null => false
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
  end

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.boolean  "requires_reconciliation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "payment_type_id"
    t.float    "amount"
    t.boolean  "reconciled"
    t.string   "verification_string"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "ticket_types", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "ticket_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                            :null => false
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
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
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
