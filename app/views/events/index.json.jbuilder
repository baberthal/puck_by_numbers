json.array!(@events) do |event|
  json.extract! event, :id, :event_number, :period, :seconds, :event_type, :event_team, :shot_type, :home_score, :away_score, :event_length, :home_skaters, :away_skaters
  json.url event_url(event, format: :json)
end
