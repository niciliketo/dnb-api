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

    # Error class for Invalid Order Reason
    class InvalidOrderReason < StandardError
      def initialize(msg = 'The order reason is not valid.')
        super
      end
    end

    # Error class for Invalid Product
    class InvalidProduct < StandardError
      def initialize(msg = 'The product is not valid.')
        super
      end
    end

    # Error class for Invalid Product Component
    class InvalidProductComponents < StandardError
      def initialize(msg = 'The product component(s) are not valid.')
        super
      end
    end

    # Error class for Invalid Product Component
    class InvalidProductSubComponent < StandardError
      def initialize(msg = 'The product sub component is not valid.')
        super
      end
    end

    # Error class for Invalid Product Component
    class InvalidReportType < StandardError
      def initialize(msg = 'The report type is not valid. Please ensure mandatory attributes are set.')
        super
      end
    end

    # Error class for Invalid Product Component
    class ReportTypeNotImplemented < StandardError
      def initialize(msg = 'Sorry. The report type is not yet implemented. Provide or implement this report type.')
        super
      end
    end
  end
end
