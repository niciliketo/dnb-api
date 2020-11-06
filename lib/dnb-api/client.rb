# frozen_string_literal: true

require 'faraday'
require 'json'
module Dnb
  module Api
    ##
    # Client connects to the creditsafe api and provides methods
    # matching API calls.
    class Client
      include Dnb::Api::Utils
      def initialize(params)
        check_params(params)

        @api_key = params[:api_key]
        @secret = params[:secret]
        @loglevel = params[:loglevel] || Logger::WARN

        @environment = params[:environment] || :production
        # Proxy either makes real calls or dummy calls...
        if @environment == :dummy
          @proxy = DummyClient.new(params)
        else
          @proxy = RealClient.new(params)
        end
      end

      def connect
        @proxy.connect
        @access_token = @proxy.access_token
        true
      end

      def connected?
        @proxy.connected?
      end

      def criteria_search(params)
        @proxy.criteria_search(params)
      end

      def company_credit_report(connect_id)
        @proxy.company_credit_report(connect_id)
      end

      private

      def check_params(params)
        missing = MANDATORY_PARAMS.find_all { |p| params[p].nil? }
        unexpected = params.reject { |k| EXPECTED_PARAMS.include?(k) }
        raise(IncorrectParams, "Missing params: #{missing}") unless missing.empty?
        raise(IncorrectParams, "Unexpected params: #{unexpected}") unless unexpected.empty?
      end

      def auth_header
        { 'Authorization' => @access_token }
      end

      def check_connected
        raise NotConnected if @access_token.nil?
      end
    end
  end
end
