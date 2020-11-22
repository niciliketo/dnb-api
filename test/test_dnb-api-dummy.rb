require 'minitest/autorun'
require 'dnb-api'
require 'vcr'
module Dnb
  # Test the dummy version of the API
  class DummyApiTest < Minitest::Test
    def setup
      Dnb::Api.logger.level = Logger::INFO
    end

    def test_initialize_success
      client = Dnb::Api::Client.new(api_key: 'foo', secret: 'bar', environment: :dummy)
      assert_equal %i[@proxy],
                   client.instance_variables
    end

    def test_initialize_wrong_param
      assert_raises Dnb::Api::IncorrectParams do
        Dnb::Api::Client.new(api_key: 'foo', secret: 'bar', environmen: :dummy)
      end
    end

    def test_initialize_missing_param
      assert_raises Dnb::Api::IncorrectParams do
        Dnb::Api::Client.new(api_key: 'foo')
      end
    end

    def test_authenticate_response
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      assert client.connected?
    end

    def test_authenticate_fails_response
      client = Dnb::Api::Client.new(api_key: 'notkey', secret: 'secret', environment: :dummy)
      assert !client.connected?
    end

    def test_company_search_response
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.criteria_search(countryISOAlpha2Code: 'GB', searchTerm: 'Market Dojo')

      assert_equal '216832106', result['searchCandidates'][0]['organization']['duns'],
                   'Incorrect duns returned'
    end

    def test_company_profile_response
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.company_profile('216832106', Dnb::Api::ReportType.new)

      assert_equal '07332766', result['organization']['registrationNumbers'][0]['registrationNumber']
    end

    def test_can_assign_log_level
      Dnb::Api.logger.level = Logger::FATAL
      assert_equal 4, Dnb::Api.logger.level
    end
  end
end
