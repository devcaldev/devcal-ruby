# bundle exec ruby example/main.rb API_KEY

require 'devcal'

addr = 'devcal.fly.dev:50051'
api_key = ARGV[0]

client = Devcal.new_with_credentials(addr, api_key)

new_event = client.insert_event(Dtstart: Time.now.to_s, Dtend: (Time.now + 3600).to_s, Rrule: 'FREQ=DAILY', Props: '{"calendar_id":"c1"}')
pp ['new_event',new_event]


retrived_event = client.get_event(ID: new_event.ID)
pp ['retrived_event',retrived_event]

listed_events = client.list_events(Date: Time.now.to_s, Period: 'year')
listed_events.each do |le|
  pp ['listed_event', le]
end

client.update_event(ID: retrived_event.ID, Props: '{"calendar_id":"c2"}')

found_events = client.find_events(Props: '{"calendar_id":"c2"}')
found_events.each do |le|
  pp ['found_events', le]
end

updated_event = client.get_event(ID: retrived_event.ID)
pp ['updated_event', updated_event]

client.delete_event(ID: updated_event.ID)