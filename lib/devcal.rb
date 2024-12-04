# frozen_string_literal: true

require_relative "devcal/version"
require_relative "devcal/devcal_services_pb"

module Devcal
  class Error < StandardError; end

  class InsecureClient
    def initialize(addr, api_key)
      @metadata = { authorization: "Bearer #{api_key}" }
      @stub = ::Devcal::EventsService::Stub.new(addr, :this_channel_is_insecure)
    end

    def insert_event(**params)
      @stub.insert_event(::Devcal::InsertEventParams.new(params), metadata: @metadata)
    end

    def get_event(**params)
      @stub.get_event(::Devcal::GetEventParams.new(params), metadata: @metadata)
    end

    def list_events(**params)
      @stub.list_events(::Devcal::ListEventsParams.new(params), metadata: @metadata)
    end

    def update_event(**params)
      @stub.update_event(::Devcal::UpdateEventParams.new(params), metadata: @metadata)
    end

    def delete_event(**params)
      @stub.delete_event(::Devcal::DeleteEventParams.new(params), metadata: @metadata)
    end
  end

  class SecureClient
    def initialize(addr, api_key)
      @call_creds = GRPC::Core::CallCredentials.new(proc { { authorization: "Bearer #{api_key}" } })
      @stub = ::Devcal::EventsService::Stub.new(addr, GRPC::Core::ChannelCredentials.new())
    end

    def insert_event(**params)
      @stub.insert_event(::Devcal::InsertEventParams.new(params), credentials: @call_creds)
    end

    def get_event(**params)
      @stub.get_event(::Devcal::GetEventParams.new(params), credentials: @call_creds)
    end

    def list_events(**params)
      @stub.list_events(::Devcal::ListEventsParams.new(params), credentials: @call_creds)
    end

    def update_event(**params)
      @stub.update_event(::Devcal::UpdateEventParams.new(params), credentials: @call_creds)
    end

    def delete_event(**params)
      @stub.delete_event(::Devcal::DeleteEventParams.new(params), credentials: @call_creds)
    end
  end
  
  def self.new_with_credentials(addr, api_key)
    SecureClient.new(addr, api_key)
  end

  def self.new_with_insecure_credentials(addr, api_key)
    InsecureClient.new(addr, api_key)
  end
end
