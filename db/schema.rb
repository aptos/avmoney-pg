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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150816191022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer "client_id"
    t.string  "client_name"
    t.integer "project_id"
    t.string  "notes"
    t.date    "date"
    t.float   "hours"
    t.float   "rate"
    t.decimal "expense",     precision: 8, scale: 2
    t.float   "tax_rate"
    t.decimal "tax_paid",    precision: 8, scale: 2
    t.string  "status",                              default: "Active"
    t.integer "invoice_id"
  end

  add_index "activities", ["client_id"], name: "index_activities_on_client_id", using: :btree
  add_index "activities", ["invoice_id"], name: "index_activities_on_invoice_id", using: :btree
  add_index "activities", ["project_id"], name: "index_activities_on_project_id", using: :btree

  create_table "clients", force: true do |t|
    t.string  "name"
    t.float   "rate"
    t.float   "tax_rate"
    t.string  "address"
    t.string  "deliveries"
    t.string  "contact"
    t.string  "email"
    t.string  "phone"
    t.string  "cell"
    t.string  "contact2"
    t.string  "email2"
    t.string  "phone2"
    t.string  "cell2"
    t.text    "active_projects",   default: [],    array: true
    t.text    "archived_projects", default: [],    array: true
    t.integer "base_invoice_id",   default: 1
    t.boolean "archived",          default: false
  end

  create_table "invoices", force: true do |t|
    t.integer "invoice_number"
    t.string  "po_number"
    t.string  "wo_number"
    t.integer "client_id"
    t.float   "hours_sum"
    t.decimal "hours_amount",   precision: 8, scale: 3
    t.decimal "expenses",       precision: 8, scale: 2
    t.float   "tax"
    t.decimal "invoice_total",  precision: 8, scale: 2
    t.text    "activities",                             default: [], array: true
    t.json    "client_data"
    t.integer "project_id"
    t.string  "status"
    t.date    "open_date"
    t.date    "paid_date"
    t.decimal "paid",           precision: 8, scale: 2
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id", using: :btree
  add_index "invoices", ["project_id"], name: "index_invoices_on_project_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer "invoice_id"
    t.integer "invoice_number"
    t.integer "client_id"
    t.string  "project"
    t.decimal "amount",         precision: 8, scale: 2
    t.string  "notes"
    t.date    "date"
  end

  add_index "payments", ["client_id"], name: "index_payments_on_client_id", using: :btree
  add_index "payments", ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree

  create_table "projects", force: true do |t|
    t.string  "name"
    t.string  "wo_number"
    t.string  "po_number"
    t.integer "cap"
    t.integer "client_id"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "users", force: true do |t|
    t.string "email"
    t.string "name"
    t.string "auth_token"
  end

end
