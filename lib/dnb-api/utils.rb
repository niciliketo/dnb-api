# frozen_string_literal: true

require 'faraday'
require 'json'
module Dnb
  module Api
    ##
    # Utils provides some methods used by other classes.
    module Utils
      def build_url(path, item = nil, params = nil)
        @environment ||= :dummy
        base_url = @environment == :production ? PRODUCTION_BASE_URL : SANDBOX_BASE_URL
        url = "#{base_url}#{path}"
        url += "/#{item}" unless item.nil?
        url += "?#{params}" unless params.nil?
        url
      end

      def build_monitoring_registration_url(reference, duns)
        "#{build_url(MONITORING_REGISTRATIONS_DETAILS_PATH)}/#{reference}/duns/#{duns}"
      end
    end
  end
end
