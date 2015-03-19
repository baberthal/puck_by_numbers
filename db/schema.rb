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

ActiveRecord::Schema.define(version: 20150319030244) do

  create_table "games", force: :cascade do |t|
    t.integer  "season_id",   limit: 4
    t.integer  "game_number", limit: 4, null: false
    t.integer  "gcode",       limit: 8, null: false
    t.integer  "status",      limit: 1, null: false
    t.string   "home_team",   limit: 3, null: false
    t.string   "away_team",   limit: 3, null: false
    t.integer  "fscore_home", limit: 2, null: false
    t.integer  "fscore_away", limit: 2, null: false
    t.datetime "game_start",            null: false
    t.datetime "game_end",              null: false
    t.integer  "periods",     limit: 1, null: false
  end

  add_index "games", ["season_id"], name: "index_games_on_season_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer "season_years", limit: 8, null: false, unsigned: true
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
