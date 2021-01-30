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

      def cleanse_match(_params)
        check_connected
        file = File.read(get_path('cleanse_match.json'))
        JSON.parse file
      end

      def company_profile(_duns, report_type)
        check_connected
        file =
          if company_report_request?(report_type)
            company_profile_birstd
          else
            company_profile_trade_credit
          end
        JSON.parse file
      end

      def monitoring_registrations_list
        check_connected
        file = File.read(get_path('monitoring_registrations_list.json'))
        JSON.parse file
      end

      def monitoring_registration_details(_reference)
        check_connected
        file = File.read(get_path('monitoring_registration_details.json'))
        JSON.parse file
      end

      def monitoring_registration_add(_reference, _duns, _customer_reference)
        check_connected
        file = File.read(get_path('monitoring_registration_add.json'))
        JSON.parse file
      end

      def monitoring_registration_remove(_reference, _duns)
        check_connected
        file = File.read(get_path('monitoring_registration_remove.json'))
        JSON.parse file
      end
      private

      def get_path(file)
        "#{__dir__}/../../dummy_responses/#{file}"
      end

      def company_profile_trade_credit
        File.read(get_path('company_profile_trade_credit.json'))
      end

      def company_profile_birstd
        File.read(get_path('company_profile_birstd.json'))
      end
    end
  end
end
