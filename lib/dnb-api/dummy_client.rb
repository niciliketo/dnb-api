# frozen_string_literal: true

require 'faraday'
require 'json'
require 'dnb-api/base_client'
module Dnb
  module Api
    ##
    # Dummy client returns canned responses and does not
    # connect to the dnb api.
    # We do still check that the api_key and secret are correct
    # So we can simulate fail responses
    class DummyClient < BaseClient
      def connect
        @access_token = DUMMY_ACCESS_TOKEN if @api_key == DUMMY_KEY && @secret == DUMMY_SECRET
        !@access_token.nil?
      end

      def connected?
        !@access_token.nil?
      end

      def criteria_search(_params)
        check_connected
        file = File.read(get_path('criteria_search.json'))
        JSON.parse file
      end

      def company_profile(_duns, report_type)
        check_connected
        file = File.read(get_path('company_profile.json'))
        JSON.parse file
      end

      private

      def get_path(file)
        "#{__dir__}/../../dummy_responses/#{file}"
      end
    end
  end
end
