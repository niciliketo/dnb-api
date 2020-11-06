# frozen_string_literal: true

require 'faraday'
require 'json'
require 'base64'

module Dnb
  module Api
    ##
    # Client connects to the dnb api and provides methods
    # matching API calls.
    class BaseClient
      include Dnb::Api::Utils
      attr_accessor :access_token
      def initialize(params)
        @api_auth = Base64.strict_encode64(params[:api_key] + ':' + params[:secret])
        @loglevel = params[:loglevel] || Logger::WARN

        @environment = params[:environment] || :production
      end

      private

      def check_params(params)
        missing = MANDATORY_PARAMS.find_all{ |p| params[p].nil? }
        unexpected = params.reject { |k| EXPECTED_PARAMS.include?(k) }
        raise(IncorrectParams, "Missing params: #{missing}") unless missing.empty?
        raise(IncorrectParams, "Unexpected params: #{unexpected}") unless unexpected.empty?
      end

      def auth_header
        { 'authorization' => "Bearer #{@access_token}" }
      end

      def check_connected
        raise NotConnected if @access_token.nil?
      end
    end
  end
end
