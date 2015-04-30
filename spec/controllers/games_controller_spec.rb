require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  render_views
  describe "index" do
    before do
      Game.create!([{
        game_number: 1,
        season_years: 20142015,
        gcode: 20001,
        home_team_id: 27,
        away_team_id: 16,
        fscore_home: 3,
        fscore_away: 4,
        game_start: DateTime.new(2014, 10, 8, 19, 15, 0, '-4'),
        game_end: DateTime.new(2014, 10, 8, 21, 55, 0, '-4'),
        periods: 3
      },
      {
        game_number: 2,
        season_years: 20142015,
        gcode: 20002,
        home_team_id: 3,
        away_team_id: 22,
        fscore_home: 2,
        fscore_away: 1,
        game_start: DateTime.new(2014, 10, 8, 19, 35, 0, '-4'),
        game_end: DateTime.new(2014, 10, 8, 22, 03, 0, '-4'),
        periods: 3
      }])

      xhr :get, :index, format: :json, q: q
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_date
      ->(object) { object["date"] }
    end

    context "when the search finds results" do
      let(:q) { '10-8' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include '2014-10-08'" do
        expect(results.map(&extract_date)).to include('2014-10-08')
      end
    end

    context "when the search doesn't find results" do
      let(:q) { 'montreal' }
      it 'should return all results' do
        expect(results.size).to eq(2)
      end
    end

  end
end
