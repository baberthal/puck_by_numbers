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

ActiveRecord::Schema.define(version: 20150515220701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", id: false, force: :cascade do |t|
    t.integer "event_number",                  null: false
    t.integer "period",            limit: 2,   null: false
    t.float   "seconds",                       null: false
    t.string  "event_type",        limit: 255, null: false
    t.integer "event_team_id"
    t.integer "event_player_1_id"
    t.integer "event_player_2_id"
    t.integer "event_player_3_id"
    t.integer "away_G_id"
    t.integer "home_G_id"
    t.string  "description",       limit: 255
    t.integer "home_score",        limit: 2,   null: false
    t.integer "away_score",        limit: 2,   null: false
    t.float   "event_length"
    t.integer "home_skaters",      limit: 2,   null: false
    t.integer "away_skaters",      limit: 2,   null: false
    t.integer "situation"
    t.integer "season_years",      limit: 8
    t.integer "gcode",             limit: 8
    t.integer "a1_id"
    t.integer "a2_id"
    t.integer "a3_id"
    t.integer "a4_id"
    t.integer "a5_id"
    t.integer "a6_id"
    t.integer "h1_id"
    t.integer "h2_id"
    t.integer "h3_id"
    t.integer "h4_id"
    t.integer "h5_id"
    t.integer "h6_id"
    t.text    "away_players"
    t.text    "home_players"
    t.integer "game_id"
  end

  add_index "events", ["away_G_id"], name: "index_events_on_away_G_id", using: :btree
  add_index "events", ["away_skaters"], name: "index_events_on_away_skaters", using: :btree
  add_index "events", ["event_number"], name: "index_events_on_event_number", using: :btree
  add_index "events", ["event_player_1_id"], name: "index_events_on_event_player_1_id", using: :btree
  add_index "events", ["event_player_2_id"], name: "index_events_on_event_player_2_id", using: :btree
  add_index "events", ["event_player_3_id"], name: "index_events_on_event_player_3_id", using: :btree
  add_index "events", ["event_team_id"], name: "index_events_on_event_team_id", using: :btree
  add_index "events", ["gcode"], name: "index_events_on_gcode", using: :btree
  add_index "events", ["home_G_id"], name: "index_events_on_home_G_id", using: :btree
  add_index "events", ["home_skaters"], name: "index_events_on_home_skaters", using: :btree
  add_index "events", ["season_years"], name: "index_events_on_season_years", using: :btree
  add_index "events", ["situation"], name: "index_events_on_situation", using: :btree

  create_table "game_charts", force: :cascade do |t|
    t.string   "chart_type",   limit: 255
    t.text     "data"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "season_years", limit: 8
    t.integer  "gcode"
    t.integer  "situation"
    t.integer  "team_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "game_number"
    t.integer  "gcode",                  limit: 8, null: false
    t.integer  "status",                 limit: 2
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "fscore_home",            limit: 2, null: false
    t.integer  "fscore_away",            limit: 2, null: false
    t.datetime "game_start",                       null: false
    t.datetime "game_end",                         null: false
    t.integer  "periods",                limit: 2, null: false
    t.integer  "season_years",           limit: 8
    t.date     "date"
    t.text     "home_player_id_numbers"
    t.integer  "event_count"
    t.text     "away_player_id_numbers"
    t.integer  "game_charts_count"
    t.integer  "session"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["game_end"], name: "index_games_on_game_end", using: :btree
  add_index "games", ["game_start"], name: "index_games_on_game_start", using: :btree
  add_index "games", ["gcode"], name: "index_games_on_gcode", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer "event_id"
    t.integer "distance"
    t.string  "home_zone",            limit: 3
    t.integer "x_coord"
    t.integer "y_coord"
    t.integer "location_section",     limit: 2
    t.integer "new_location_section", limit: 2
    t.integer "new_x_coord"
    t.integer "new_y_coord"
    t.integer "event_number"
    t.integer "gcode"
    t.integer "season_years"
  end

  add_index "locations", ["event_id"], name: "index_locations_on_event_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer "player_id"
    t.integer "event_id"
    t.string  "event_role", limit: 3
  end

  add_index "participants", ["event_id"], name: "index_participants_on_event_id", using: :btree
  add_index "participants", ["player_id"], name: "index_participants_on_player_id", using: :btree

  create_table "player_game_summaries", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "goals"
    t.integer  "a1"
    t.integer  "a2"
    t.integer  "points"
    t.integer  "ind_sc"
    t.integer  "ind_cf"
    t.integer  "c_diff"
    t.integer  "f_diff"
    t.integer  "g_diff"
    t.integer  "cf"
    t.integer  "ff"
    t.integer  "zso"
    t.integer  "zsd"
    t.integer  "blocks"
    t.integer  "fo_won"
    t.integer  "fo_lost"
    t.integer  "hits"
    t.integer  "hits_taken"
    t.integer  "pen"
    t.integer  "pen_drawn"
    t.float    "toi"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "situation",    limit: 255
    t.integer  "season_years", limit: 8
    t.integer  "gcode",        limit: 8
  end

  add_index "player_game_summaries", ["player_id"], name: "index_player_game_summaries_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string  "position",              limit: 1
    t.string  "last_name",             limit: 255
    t.string  "first_name",            limit: 255
    t.string  "number_first_last",     limit: 255
    t.integer "player_index"
    t.integer "pC"
    t.integer "pR"
    t.integer "pL"
    t.integer "pD"
    t.integer "pG"
    t.integer "team_id"
    t.text    "headshot"
    t.text    "bio"
    t.integer "external_id"
    t.integer "primary_event_count"
    t.integer "secondary_event_count"
    t.integer "tertiary_event_count"
    t.integer "event_count"
    t.boolean "active"
  end

  add_index "players", ["first_name"], name: "index_players_on_first_name", using: :btree
  add_index "players", ["last_name"], name: "index_players_on_last_name", using: :btree
  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "seasons", primary_key: "season_years", force: :cascade do |t|
  end

  create_table "team_game_summaries", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "gf"
    t.integer  "sf"
    t.integer  "msf"
    t.integer  "bsf"
    t.integer  "scf"
    t.integer  "cf"
    t.integer  "zso"
    t.integer  "hits"
    t.integer  "pen"
    t.integer  "fo_won"
    t.float    "toi"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "c_diff"
    t.integer  "f_diff"
    t.string   "situation",    limit: 255
    t.integer  "ca"
    t.integer  "season_years", limit: 8
    t.integer  "gcode",        limit: 8
  end

  add_index "team_game_summaries", ["gcode"], name: "index_team_game_summaries_on_gcode", using: :btree
  add_index "team_game_summaries", ["season_years"], name: "index_team_game_summaries_on_season_years", using: :btree
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

  add_foreign_key "events", "games"
end
