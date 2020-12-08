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
        check_params(params)
        @api_auth = Base64.strict_encode64(params[:api_key] + ':' + params[:secret])
        @loglevel = params[:loglevel] || Logger::WARN

        @environment = params[:environment] || :production

        @api_key = params[:api_key]
        @secret = params[:secret]
        @access_token = nil
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

      ##
      # Return the right base_url for the current report type
      def company_profile_path(report_type)
        if company_report_request?(report_type)
          COMPANY_REPORTS_PATH
        else
          COMPANY_PROFILE_PATH
        end
      end

      ##
      # Are we requesting a D&B 'company_report' ?
      # birstd/comprh match means yes
      def company_report_request?(report_type)
        report_type.match?(/birstd|comprh/)
      end
    end
  end
end
