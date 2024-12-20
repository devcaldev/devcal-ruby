# frozen_string_literal: true

require 'google/protobuf/well_known_types'
require_relative "devcal/version"
require_relative "devcal/devcal_services_pb"

# The Devcal module encapsulates all classes and methods related to the Devcal service.
module Devcal
  # Custom error class for the Devcal module.
  class Error < StandardError; end

  # The Client class provides methods to interact with the Devcal service.
  class Client
    # Inserts an event into the Devcal service.
    #
    # @param params [Hash] The parameters for the event, including optional :Props.
    # @return [Object] The response from the insert_event call.
    def insert_event(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.insert_event(::Devcal::InsertEventParams.new(params), **@call_opts)
    end

    # Retrieves an event from the Devcal service.
    #
    # @param params [Hash] The parameters for retrieving the event.
    # @return [Object] The response from the get_event call.
    def get_event(**params)
      @stub.get_event(::Devcal::GetEventParams.new(params), **@call_opts)
    end

    # Lists events from the Devcal service.
    #
    # @param params [Hash] The parameters for listing events, including optional :Props.
    # @return [Object] The response from the list_events call.
    def list_events(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.list_events(::Devcal::ListEventsParams.new(params), **@call_opts)
    end

    # Updates an event in the Devcal service.
    #
    # @param params [Hash] The parameters for updating the event, including optional :Props.
    # @return [Object] The response from the update_event call.
    def update_event(**params)
      params[:Props] = Google::Protobuf::Struct.from_hash(params[:Props]) if params[:Props]
      @stub.update_event(::Devcal::UpdateEventParams.new(params), **@call_opts)
    end

    # Deletes an event from the Devcal service.
    #
    # @param params [Hash] The parameters for deleting the event.
    # @return [Object] The response from the delete_event call.
    def delete_event(**params)
      @stub.delete_event(::Devcal::DeleteEventParams.new(params), **@call_opts)
    end
  end

  # The InsecureClient class provides an insecure connection to the Devcal service.
  class InsecureClient < Client
    # Initializes a new InsecureClient instance.
    #
    # @param addr [String] The address of the Devcal service.
    # @param api_key [String] The API key for authentication.
    def initialize(addr, api_key)
      @call_opts = { metadata: { authorization: "Bearer #{api_key}" } }
      @stub = ::Devcal::EventsService::Stub.new(addr, :this_channel_is_insecure)
    end
  end

  # The SecureClient class provides a secure connection to the Devcal service.
  class SecureClient < Client
    # Initializes a new SecureClient instance.
    #
    # @param addr [String] The address of the Devcal service.
    # @param api_key [String] The API key for authentication.
    def initialize(addr, api_key)
      @call_opts = {credentials: GRPC::Core::CallCredentials.new(proc { { authorization: "Bearer #{api_key}" } })}
      @stub = ::Devcal::EventsService::Stub.new(addr, GRPC::Core::ChannelCredentials.new())
    end
  end
  
  # Creates a new SecureClient with the given credentials.
  #
  # @param addr [String] The address of the Devcal service.
  # @param api_key [String] The API key for authentication.
  # @return [SecureClient] A new instance of SecureClient.
  def self.new_with_credentials(addr, api_key)
    SecureClient.new(addr, api_key)
  end

  # Creates a new InsecureClient with the given credentials.
  #
  # @param addr [String] The address of the Devcal service.
  # @param api_key [String] The API key for authentication.
  # @return [InsecureClient] A new instance of InsecureClient.
  def self.new_with_insecure_credentials(addr, api_key)
    InsecureClient.new(addr, api_key)
  end
end
