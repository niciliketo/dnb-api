# frozen_string_literal: true

require 'faraday'
require 'json'
require 'dnb-api/base_client'
require 'time'

module Dnb
  module Api
    ##
    # Real client makes real calls to connects to the D&B api.
    class RealClient < BaseClient
      def connect
        url = build_url(AUTH_PATH)

        Dnb::Api.logger.debug("Making request for token to #{url}")
        response = Faraday.post do |req|
          req.url url
          req.headers[:authorization] = "Basic #{@api_auth}"
          req.headers[:content_type] = 'application/json'
          req.body = '{ "grant_type" : "client_credentials" }'
        end

        Dnb::Api.logger.debug('Response received')
        Dnb::Api.logger.debug("Response: #{response.body}")
        response_json = JSON.parse response.body
        Dnb::Api.logger.debug("response: #{response_json}")
        @access_token = response_json['access_token']
        true
      end

      def connected?
        !@access_token.nil?
      end

      def criteria_search(params)
        url = build_url(CRITERIA_SEARCH_PATH)
        Dnb::Api.logger.debug("Making request for criteria_search to #{url} with params #{params}")
        response = Faraday.post do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
          req.body = params.to_json
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def cleanse_match(params)
        url = build_url(CLEANSE_MATCH_PATH)
        Dnb::Api.logger.debug("Making request for cleanse_match to #{url} with params #{params}")
        response = Faraday.get do |req|
          req.url url
          req.params = params
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def company_profile(duns, report_type)
        url = build_url(company_profile_path(report_type), duns, report_type)
        Dnb::Api.logger.debug("Making request for company_profile to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registrations_list
        url = build_url(MONITORING_REGISTRATIONS_LIST_PATH)
        Dnb::Api.logger.debug("Making request for monitoring_registrations_list to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registration_details(reference)
        url = build_url(MONITORING_REGISTRATIONS_DETAILS_PATH, reference)
        Dnb::Api.logger.debug("Making request for monitoring_registration_details to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registration_add(reference, duns, customer_reference)
        url = build_monitoring_registration_url(reference, duns)
        Dnb::Api.logger.debug("Making request for monitoring_registration_add to #{url}")
        response = Faraday.post do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
          req.body = { customerReference: customer_reference }.to_json
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registration_remove(reference, duns)
        url = build_monitoring_registration_url(reference, duns)
        Dnb::Api.logger.debug("Making request for monitoring_registration_remove to #{url}")
        response = Faraday.delete do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registration_pull(reference)
        url = build_monitoring_registration_url(reference, nil, :pull)
        Dnb::Api.logger.debug("Making request for monitoring_registration_pull to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def monitoring_registration_replay(reference, max_notifications, replay_start_time)
        url = build_monitoring_registration_url(reference, nil, :replay)
        Dnb::Api.logger.debug("Making request for monitoring_registration_pull to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
          req.params = { maxNotifications: max_notifications, replayStartTimestamp: replay_start_time.utc.iso8601 }
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end
    end
  end
end
