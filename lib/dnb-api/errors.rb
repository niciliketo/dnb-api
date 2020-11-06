# frozen_string_literal: true

##
# Outer namespace to Dnb::API
module Dnb
  ##
  # Inner namespace to Dnb::API
  module Api
    ##
    # Error class for API connection issues
    class NotConnected < StandardError
      def initialize(msg = 'Please connect before making a request')
        super
      end
    end

    # Error class for incorrect params
    class IncorrectParams < StandardError
      def initialize(msg = 'The provided params were incorrect')
        super
      end
    end
  end
end
