# frozen_string_literal: true

require 'logger'
require 'dnb-api/client'
##
# Outer namespace to Dnb::API
module Dnb
  ##
  # Inner namespace to Dnb::API
  module Api
    class << self
      def logger
        @logger ||= defined?(Rails.logger) ? Rails.logger : Logger.new($stdout)
      end

      def logger=(logger)
        @logger = logger
      end
    end
  end
end
