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

      def cleanse_match(params)
        @proxy.cleanse_match(params)
      end

      def company_profile(duns, report_type)
        @proxy.company_profile(duns, report_type)
      end

      ##
      # List Registrations (for subscriber):
      # Returns a list of all Registrations for a specific subscriber
      # (based on authentication code). The system will return a list
      # of Registration identifiers, but no other details.
      # https://directplus.documentation.dnb.com/openAPI.html?apiID=monListRegistrations
      def monitoring_registrations_list
        @proxy.monitoring_registrations_list
      end

      ##
      # Get Registration Details: Returns the settings for a specific Registration.
      # https://directplus.documentation.dnb.com/openAPI.html?apiID=monGetRegistration
      def monitoring_registration_details(reference)
        @proxy.monitoring_registration_details(reference)
      end

      ##
      # Add Single D-U-N-S Number to a LOD Registration:
      # At any time after a registration is created,
      # you may add a single D-U-N-S Number to the registration.
      # https://directplus.documentation.dnb.com/openAPI.html?apiID=monAddSingleDunsToRegistration
      def monitoring_registration_add(reference, duns, customer_reference = '12345')
        @proxy.monitoring_registration_add(reference, duns, customer_reference)
      end

      ##
      # Remove Single D-U-N-S Number from a LOD Registration:
      # At any time after a registration is created, you may remove single D-U-N-S Number
      # from the registration; any existing notifications for the deleted D-U-N-S Number
      # will still be delivered.
      # https://directplus.documentation.dnb.com/openAPI.html?apiID=monRemoveSingleDunsFromRegistration
      def monitoring_registration_remove(reference, duns)
        @proxy.monitoring_registration_remove(reference, duns)
      end

      ##
      # Pull new Notifications: Provides the ability to Pull notifications for a registration.
      # The registration must have been created with deliveryTrigger set to API_PULL
      # in order to use the pull API.
      # If maxNotifications is not specified then one notification will be returned
      # (if available). Notifications are available for up to 4 days to be pulled.
      # It is recommended that pull API is only used for small registrations as it is
      # more efficient and effective to have large numbers of notifications delivered via push
      # (files). Notifications which are pulled are available for replay (to be re-pulled)
      # via the replay API for 14 days. If notifications are not pulled for 4 days then
      # they will be removed and a re-seed will be necessary.
      # https://directplus.documentation.dnb.com/openAPI.html?apiID=monRegistrationPullAPI
      def monitoring_registration_pull(reference, duns)
        @proxy.monitoring_registration_pull(reference, duns)
      end

      ##
      # Replay (re-pull) Notifications: Provides the ability to replay (re-pull)
      # previously pulled notifications for a registration. Notifications which were pulled
      # are available for replay (to be re-pulled) via the replay API for 14 days.
      # If maxNotifications is not specified then one notification will be returned
      # (if available). The replay API will return to the first notification after
      # timestamp indicated by the mandatory replayStartTimestamp parameter up to the
      # maxNotifications number if available.

      def monitoring_registration_replay(reference, duns)
        @proxy.monitoring_registration_replay(reference, duns)
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
