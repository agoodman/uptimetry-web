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

ActiveRecord::Schema.define(:version => 20130211205552) do

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string    "name"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "domains", ["name"], :name => "index_domains_on_name"
  add_index "domains", ["user_id"], :name => "index_domains_on_user_id"

  create_table "endpoints", :force => true do |t|
    t.string    "url"
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "last_successful_attempt"
    t.boolean   "up",                      :default => true
    t.string    "secret_key"
    t.string    "css_selector"
    t.string    "xpath"
    t.integer   "down_count",              :default => 0
    t.integer   "domain_id"
    t.integer   "retry_count",             :default => 3
    t.integer   "retry_delay",             :default => 30
  end

  add_index "endpoints", ["domain_id"], :name => "index_endpoints_on_domain_id"
  add_index "endpoints", ["secret_key"], :name => "index_sites_on_secret_key"

  create_table "users", :force => true do |t|
    t.string    "email"
    t.string    "encrypted_password",  :limit => 128
    t.string    "salt",                :limit => 128
    t.string    "confirmation_token",  :limit => 128
    t.string    "remember_token",      :limit => 128
    t.boolean   "email_confirmed",                    :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "first_name"
    t.string    "last_name"
    t.integer   "site_allowance",                     :default => 0
    t.string    "customer_reference"
    t.string    "card_last_four"
    t.string    "card_exp_month"
    t.string    "card_exp_year"
    t.string    "card_type"
    t.date      "next_invoice_date"
    t.string    "api_token"
    t.string    "heroku_id"
    t.string    "heroku_callback_url"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
