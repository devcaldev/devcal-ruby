# bundle exec ruby example/main.rb API_KEY

require 'devcal'

addr = 'devcal.fly.dev:50051'
api_key = ARGV[0]

client = Devcal.new_with_credentials(addr, api_key)

new_event = client.insert_event(dtstart: Time.now, dtend: (Time.now + 3600), rrule: 'FREQ=DAILY', props: {"calendar_id" => "c1"})
pp ['new_event',new_event]


retrived_event = client.get_event(id: new_event.id)
pp ['retrived_event',retrived_event]

listed_events = client.list_events(date: Time.now, period: 'year')
listed_events.each do |le|
  pp ['listed_event', le]
end

client.update_event(id: retrived_event.id, props: {"calendar_id" => "c2"})

found_events = client.list_events(props: {"calendar_id" => "c2"})
found_events.each do |le|
  pp ['found_events', le]
end

updated_event = client.get_event(id: retrived_event.id)
pp ['updated_event', updated_event]

client.delete_event(id: updated_event.id)