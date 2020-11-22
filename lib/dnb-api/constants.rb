# frozen_string_literal: true

module Dnb
  module Api
    # Some constants we use
    MANDATORY_PARAMS = %i[api_key secret].freeze
    EXPECTED_PARAMS = %i[api_key secret log_level environment].freeze
    # SANDBOX_BASE_URL = 'https://connect.sandbox.creditsafe.com/v1'
    PRODUCTION_BASE_URL = 'https://plus.dnb.com'
    AUTH_PATH = '/v2/token'
    CRITERIA_SEARCH_PATH = '/v1/search/criteria'
    COMPANY_REPORTS_PATH = '/v1/reports/duns'
    COMPANY_PROFILE_PATH = '/v1/data/duns'
    HEADERS = { 'Content-Type' => 'application/json' }.freeze
  end
end