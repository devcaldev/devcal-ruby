# frozen_string_literal: true

require 'google/protobuf/well_known_types'
require_relative "devcal/version"
require_relative "devcal/devcal_services_pb"

module Devcal
  class Error < StandardError; end

  class Client
    def insert_event(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.insert_event(::Devcal::InsertEventParams.new(params), **@call_opts)
    end

    def get_event(**params)
      @stub.get_event(::Devcal::GetEventParams.new(params), **@call_opts)
    end

    def list_events(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.list_events(::Devcal::ListEventsParams.new(params), **@call_opts)
    end

    def update_event(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.update_event(::Devcal::UpdateEventParams.new(params), **@call_opts)
    end

    def delete_event(**params)
      @stub.delete_event(::Devcal::DeleteEventParams.new(params), **@call_opts)
    end
  end

  class InsecureClient < Client
    def initialize(addr, api_key)
      @call_opts = { metadata: { authorization: "Bearer #{api_key}" } }
      @stub = ::Devcal::EventsService::Stub.new(addr, :this_channel_is_insecure)
    end
  end

  class SecureClient < Client
    def initialize(addr, api_key)
      @call_opts = {credentials: GRPC::Core::CallCredentials.new(proc { { authorization: "Bearer #{api_key}" } })}
      @stub = ::Devcal::EventsService::Stub.new(addr, GRPC::Core::ChannelCredentials.new())
    end
  end
  
  def self.new_with_credentials(addr, api_key)
    SecureClient.new(addr, api_key)
  end

  def self.new_with_insecure_credentials(addr, api_key)
    InsecureClient.new(addr, api_key)
  end
end
