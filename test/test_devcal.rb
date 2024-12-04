# frozen_string_literal: true

require "test_helper"

class TestDevcal < Minitest::Test
  def setup
    @addr = 'localhost:50051'
    @api_key = 'YWQ5I+5PbcUmIUNdb4oZ0EsqsjZ/9heZGMcQp0jLXNDLcqZj4AwIzCJ0T6HeqQqLsDj7v4AyDt3CC33J89wZFA=='
    @client = Devcal.new_with_insecure_credentials(@addr, @api_key)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Devcal::VERSION
  end

  def test_methods
    new_event = @client.insert_event(Dtstart: Time.now.to_s, Dtend: (Time.now + 3600).to_s, Rrule: 'FREQ=DAILY', Props: '{"calendar_id":"c1"}')
    assert new_event.ID
    assert new_event.Props == '{"calendar_id": "c1"}'

    retrived_event = @client.get_event(ID: new_event.ID)
    assert new_event.ID == retrived_event.ID

    listed_events = @client.list_events(Date: Time.now.to_s, Period: 'year')
    assert listed_events.to_a.length > 0

    @client.update_event(ID: retrived_event.ID, Props: '{"calendar_id":"c2"}')

    updated_event = @client.get_event(ID: retrived_event.ID)
    assert updated_event.Props == '{"calendar_id": "c2"}'

    @client.delete_event(ID: updated_event.ID)
  end
end
