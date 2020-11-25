# frozen_string_literal: true

require 'minitest/autorun'
require 'dnb-api'
require 'vcr'
module Dnb
  # Test the real version of the API
  class ApiTest < Minitest::Test
    VCR.configure do |config|
      config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
      config.hook_into :webmock
    end

    def setup
      Dnb::Api.logger.level = Logger::INFO
    end

    def test_initialize_success
      client = Dnb::Api::Client.new(api_key: 'foo', secret: 'bar', environment: :sandbox)
      assert_equal %i[@proxy],
                   client.instance_variables
    end

    def test_initialize_wrong_param
      assert_raises Dnb::Api::IncorrectParams do
        Dnb::Api::Client.new(api_key: 'foo', secret: 'bar', environmen: :sandbox)
      end
    end

    def test_initialize_missing_param
      assert_raises Dnb::Api::IncorrectParams do
        Dnb::Api::Client.new(api_key: 'foo')
      end
    end

    def test_authenticate_response
      VCR.use_cassette('connect') do
        client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :production)
        client.connect
        assert client.connected?
      end
    end

    def test_authenticate_fails_response
      VCR.use_cassette('connect_failure') do
        client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :production)
        client.connect
        assert !client.connected?
      end
    end

    def test_company_search_response
      VCR.use_cassette('criteria_search') do
        client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :production)
        client.connect
        result = client.criteria_search(countryISOAlpha2Code: 'GB', searchTerm: 'Market Dojo')

        assert_equal '216832106', result['searchCandidates'][0]['organization']['duns'],
                     'Incorrect duns returned'
      end
    end

    def test_company_profile_response
      VCR.use_cassette('company_profile') do
        client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :production)
        client.connect
        result = client.company_profile('216832106', Dnb::Api::ReportType.new)

        assert_equal '07332766', result['organization']['registrationNumbers'][0]['registrationNumber']
      end
    end

    def test_can_assign_log_level
      Dnb::Api.logger.level = Logger::FATAL
      assert_equal 4, Dnb::Api.logger.level
    end
  end
end
