# frozen_string_literal: true

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

    def test_cleanse_match_response
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.cleanse_match(countryISOAlpha2Code: 'GB', searchTerm: 'Market Dojo')

      assert_equal '216832106', result['matchCandidates'][0]['organization']['duns'],
                   'Incorrect duns returned'
    end

    def test_company_profile_response_trade_credit
      rt = 'productId=cmptcs&versionId=v1&tradeUp=hq&customerReference=12345&orderReason=6332&reportFormat=html'
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.company_profile('216832106', rt)

      assert_equal '07332766', result['organization']['registrationNumbers'][0]['registrationNumber']
    end

    def test_company_profile_response_birstd
      rt = 'productId=birstd&inLanguage=en-US&reportFormat=PDF'
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.company_profile('216832106', rt)
      assert_equal 'application/pdf', result['contents'][0]['contentFormat']
    end

    def test_monitoring_registrations_list
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.monitoring_registrations_list
      assert_equal 'MDOJO_CMPTCS_01', result['messages']['references'][0]
    end

    def test_monitoring_registration_details
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.monitoring_registration_details('12345')
      assert_equal 'MDOJO_CMPTCS_01', result['messages']['registration']['reference']
    end

    def test_monitoring_registration_add
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.monitoring_registration_add('MDOJO_CMPTCS_01', '216832106')
      assert_equal  result.dig('information', 'message'),
                    'Requested duns added to registration successfully.', result

    end

    def test_monitoring_registration_remove
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)
      client.connect
      result = client.monitoring_registration_remove('MDOJO_CMPTCS_01', '216832106')
      assert_equal  result.dig('information', 'message'),
                    'Requested duns removed from registration  successfully.', result
    end

    def test_monitoring_registration_pull
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)

      client.connect
      result = client.monitoring_registration_pull('MDOJO_CMPTCS_01')
      assert_equal result['notifications'][0]['type'],
                   'UPDATE', result

    end

    def test_monitoring_registration_replay
      client = Dnb::Api::Client.new(api_key: 'key', secret: 'secret', environment: :dummy)

      client.connect
      result = client.monitoring_registration_replay('MDOJO_CMPTCS_01')
      assert_equal result['notifications'][0]['type'],
                   'UPDATE', result
    end

    def test_can_assign_log_level
      Dnb::Api.logger.level = Logger::FATAL
      assert_equal 4, Dnb::Api.logger.level
    end
  end
end
