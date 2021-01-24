# frozen_string_literal: true

require 'faraday'
require 'json'
require 'dnb-api/base_client'

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
        Dnb::Api.logger.debug("Making request for token to #{url}")
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
        Dnb::Api.logger.debug("Making request for token to #{url}")
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
        Dnb::Api.logger.debug("Making request for token to #{url}")
        response = Faraday.get do |req|
          req.url url
          req.headers = HEADERS.merge(auth_header)
        end
        Dnb::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end
    end
  end
end
