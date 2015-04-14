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

ActiveRecord::Schema.define(version: 20150413230747) do

  create_table "events", force: :cascade do |t|
    t.integer "game_id",           limit: 4
    t.integer "event_number",      limit: 3,   null: false, unsigned: true
    t.integer "period",            limit: 1,   null: false, unsigned: true
    t.float   "seconds",           limit: 24,  null: false
    t.string  "event_type",        limit: 255, null: false
    t.integer "event_team_id",     limit: 4
    t.integer "event_player_1_id", limit: 4
    t.integer "event_player_2_id", limit: 4
    t.integer "event_player_3_id", limit: 4
    t.integer "away_G_id",         limit: 4
    t.integer "home_G_id",         limit: 4
    t.string  "description",       limit: 255
    t.integer "home_score",        limit: 2,   null: false, unsigned: true
    t.integer "away_score",        limit: 2,   null: false, unsigned: true
    t.float   "event_length",      limit: 24
    t.integer "home_skaters",      limit: 2,   null: false, unsigned: true
    t.integer "away_skaters",      limit: 2,   null: false, unsigned: true
    t.integer "situation",         limit: 4
  end

  add_index "events", ["away_G_id"], name: "index_events_on_away_G_id", using: :btree
  add_index "events", ["event_player_1_id"], name: "index_events_on_event_player_1_id", using: :btree
  add_index "events", ["event_player_2_id"], name: "index_events_on_event_player_2_id", using: :btree
  add_index "events", ["event_player_3_id"], name: "index_events_on_event_player_3_id", using: :btree
  add_index "events", ["event_team_id"], name: "index_events_on_event_team_id", using: :btree
  add_index "events", ["game_id"], name: "index_events_on_game_id", using: :btree
  add_index "events", ["home_G_id"], name: "index_events_on_home_G_id", using: :btree

  create_table "game_charts", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.string   "chart_type", limit: 255
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "season_id",    limit: 4
    t.integer  "game_number",  limit: 4, null: false
    t.integer  "gcode",        limit: 8, null: false
    t.integer  "status",       limit: 1, null: false
    t.integer  "home_team_id", limit: 4
    t.integer  "away_team_id", limit: 4
    t.integer  "fscore_home",  limit: 2, null: false
    t.integer  "fscore_away",  limit: 2, null: false
    t.datetime "game_start",             null: false
    t.datetime "game_end",               null: false
    t.integer  "periods",      limit: 1, null: false
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["game_end"], name: "index_games_on_game_end", using: :btree
  add_index "games", ["game_start"], name: "index_games_on_game_start", using: :btree
  add_index "games", ["gcode"], name: "index_games_on_gcode", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
  add_index "games", ["season_id"], name: "index_games_on_season_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer "event_id",             limit: 4
    t.integer "distance",             limit: 3, unsigned: true
    t.string  "home_zone",            limit: 3
    t.integer "x_coord",              limit: 3
    t.integer "y_coord",              limit: 3
    t.integer "location_section",     limit: 2, unsigned: true
    t.integer "new_location_section", limit: 2, unsigned: true
    t.integer "new_x_coord",          limit: 3
    t.integer "new_y_coord",          limit: 3
  end

  add_index "locations", ["event_id"], name: "index_locations_on_event_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer "player_id",  limit: 4
    t.integer "event_id",   limit: 4
    t.string  "event_role", limit: 3
  end

  add_index "participants", ["event_id"], name: "index_participants_on_event_id", using: :btree
  add_index "participants", ["player_id"], name: "index_participants_on_player_id", using: :btree

  create_table "player_game_summaries", force: :cascade do |t|
    t.integer  "player_id",  limit: 4
    t.integer  "game_id",    limit: 4
    t.integer  "goals",      limit: 4
    t.integer  "a1",         limit: 4
    t.integer  "a2",         limit: 4
    t.integer  "points",     limit: 4
    t.integer  "ind_sc",     limit: 4
    t.integer  "ind_cf",     limit: 4
    t.integer  "c_diff",     limit: 4
    t.integer  "f_diff",     limit: 4
    t.integer  "g_diff",     limit: 4
    t.integer  "cf",         limit: 4
    t.integer  "ff",         limit: 4
    t.integer  "zso",        limit: 4
    t.integer  "zsd",        limit: 4
    t.integer  "blocks",     limit: 4
    t.integer  "fo_won",     limit: 4
    t.integer  "fo_lost",    limit: 4
    t.integer  "hits",       limit: 4
    t.integer  "hits_taken", limit: 4
    t.integer  "pen",        limit: 4
    t.integer  "pen_drawn",  limit: 4
    t.float    "toi",        limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "situation",  limit: 255
  end

  add_index "player_game_summaries", ["game_id"], name: "index_player_game_summaries_on_game_id", using: :btree
  add_index "player_game_summaries", ["player_id"], name: "index_player_game_summaries_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string  "position",          limit: 1
    t.string  "last_name",         limit: 255
    t.string  "first_name",        limit: 255
    t.string  "number_first_last", limit: 255
    t.integer "player_index",      limit: 4,   unsigned: true
    t.integer "pC",                limit: 4,   unsigned: true
    t.integer "pR",                limit: 4,   unsigned: true
    t.integer "pL",                limit: 4,   unsigned: true
    t.integer "pD",                limit: 4,   unsigned: true
    t.integer "pG",                limit: 4,   unsigned: true
    t.integer "team_id",           limit: 4
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer "season_years", limit: 8, null: false, unsigned: true
  end

  create_table "team_game_summaries", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.integer  "team_id",    limit: 4
    t.integer  "gf",         limit: 4
    t.integer  "sf",         limit: 4
    t.integer  "msf",        limit: 4
    t.integer  "bsf",        limit: 4
    t.integer  "scf",        limit: 4
    t.integer  "cf",         limit: 4
    t.integer  "zso",        limit: 4
    t.integer  "hits",       limit: 4
    t.integer  "pen",        limit: 4
    t.integer  "fo_won",     limit: 4
    t.float    "toi",        limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "c_diff",     limit: 4
    t.integer  "f_diff",     limit: 4
    t.string   "situation",  limit: 255
    t.integer  "ca",         limit: 4
  end

  add_index "team_game_summaries", ["game_id"], name: "index_team_game_summaries_on_game_id", using: :btree
  add_index "team_game_summaries", ["team_id"], name: "index_team_game_summaries_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string "name",     limit: 255
    t.string "abbr",     limit: 3
    t.string "nickname", limit: 255
    t.string "logo",     limit: 255
    t.string "color1",   limit: 255
    t.string "color2",   limit: 255
    t.string "color3",   limit: 255
    t.string "color4",   limit: 255
  end

end
