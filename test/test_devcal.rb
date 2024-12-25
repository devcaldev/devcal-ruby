# frozen_string_literal: true

# NOTE: local devcal server must be running and db/sql/seed.sql executed

require "test_helper"

class TestDevcal < Minitest::Test
  def setup
    @addr = 'localhost:50051'
    @api_key = '9fSBhI9PysfJpAdvdo7QO50J6lWunEvSi4TP0Uv3GbcXjyYi7DrZO4aNDCC+cYtTsEi5ZKyArajVml4nZlSEVg=='
    @client = Devcal.new_with_insecure_credentials(@addr, @api_key)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Devcal::VERSION
  end

  def test_methods
    
    new_event = @client.insert_event(dtstart: Time.now, dtend: (Time.now + 3600), rrule: 'FREQ=DAILY', props: {"calendar_id" => "c1"})
    assert new_event.id
    assert new_event.props["calendar_id"] == "c1"

    retrived_event = @client.get_event(id: new_event.id)
    assert new_event.id == retrived_event.id

    listed_events = @client.list_events(date: Time.now, period: 'year')
    assert listed_events.to_a.length > 0

    @client.update_event(id: retrived_event.id, props: {"calendar_id" => "c2"})

    found_events = @client.list_events(props: {"calendar_id" => "c2"})
    assert found_events.to_a.length > 0

    updated_event = @client.get_event(id: retrived_event.id)
    assert updated_event.props["calendar_id"] == "c2"

    @client.delete_event(id: updated_event.id)
  end
end
