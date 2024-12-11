# frozen_string_literal: true

require "test_helper"

class TestDevcal < Minitest::Test
  def setup
    @addr = 'localhost:50051'
    @api_key = 'Gtr4D2lXzMy+oVS2Y2rrWyiDQ81tWM/cpD5EwvA9VJJtA7E1Tx1HnT1Moqbt36DYEcivCHDbeJi6GxhnPMuNxw=='
    @client = Devcal.new_with_insecure_credentials(@addr, @api_key)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Devcal::VERSION
  end

  def test_methods
    
    new_event = @client.insert_event(Dtstart: Time.now, Dtend: (Time.now + 3600), Rrule: 'FREQ=DAILY', Props: Google::Protobuf::Struct.from_hash({"calendar_id" => "c1"}))
    assert new_event.ID
    assert new_event.Props == Google::Protobuf::Struct.from_hash({"calendar_id" => "c1"})

    retrived_event = @client.get_event(ID: new_event.ID)
    assert new_event.ID == retrived_event.ID

    listed_events = @client.list_events(Range: {Date: Time.now, Period: 'year'})
    assert listed_events.to_a.length > 0

    @client.update_event(ID: retrived_event.ID, Props: Google::Protobuf::Struct.from_hash({"calendar_id" => "c2"}))

    found_events = @client.list_events(Props: Google::Protobuf::Struct.from_hash({"calendar_id" => "c2"}))
    assert found_events.to_a.length > 0

    updated_event = @client.get_event(ID: retrived_event.ID)
    assert updated_event.Props == Google::Protobuf::Struct.from_hash({"calendar_id" => "c2"})

    @client.delete_event(ID: updated_event.ID)
  end
end
