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

ActiveRecord::Schema.define(:version => 20130629145209) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at"
    t.timestamp "locked_at"
    t.timestamp "failed_at"
    t.string    "locked_by"
    t.string    "queue"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "devices", :force => true do |t|
    t.integer   "user_id"
    t.string    "token"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string    "name"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "domains", ["name"], :name => "index_domains_on_name"
  add_index "domains", ["user_id"], :name => "index_domains_on_user_id"

  create_table "edges", :force => true do |t|
    t.integer  "src_id"
    t.integer  "dst_id"
    t.boolean  "directed"
    t.boolean  "reversed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "edges", ["dst_id"], :name => "index_edges_on_dst_id"
  add_index "edges", ["src_id", "dst_id"], :name => "index_edges_on_src_id_and_dst_id"
  add_index "edges", ["src_id"], :name => "index_edges_on_src_id"

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

  create_table "nodes", :force => true do |t|
    t.integer  "order_id"
    t.string   "url"
    t.integer  "code"
    t.string   "content_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "nodes", ["order_id"], :name => "index_nodes_on_order_id"
  add_index "nodes", ["url"], :name => "index_nodes_on_url"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.integer  "max_crawls"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "orders", ["url"], :name => "index_orders_on_url"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

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
