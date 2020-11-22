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
        @proxy = choose_proxy(params[:environment]).new(params)
      end

      def connect
        @proxy.connect
      end

      def connected?
        @proxy.connected?
      end

      def criteria_search(params)
        @proxy.criteria_search(params)
      end

      def company_profile(duns, report_type)
        @proxy.company_profile(duns, report_type)
      end

      private

      def choose_proxy(environment)
        if environment == :dummy
          DummyClient
        else
          RealClient
        end
      end
    end
  end
end
