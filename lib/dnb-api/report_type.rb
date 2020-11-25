# frozen_string_literal: true

##
# Outer namespace to Dnb::API
module Dnb
  ##
  # Inner namespace to Dnb::API
  module Api
    ##
    # Class to describe the different report types available
    # for a company. The purpose is to make it easier to choose
    # Valid report types and to generate the query string which
    # can be sent to the D&B API
    class ReportType
      attr_reader :order_reason, :product, :product_components

      # Some private constants
      PRODUCT_COMPONENTS =
        {
          :'Data Blocks' => ['Business Activity Insights', 'Derived Trade Insights', 'Hierarchies & Connections',
                            'Principals & Contacts', 'Company Financials', 'Filings & Events', 'Inquiry Insights',
                            'Sales & Marketing Insights', 'Company Information', 'External Disruption Insight',
                            'Ownership Insights', 'Spend Insights', 'Diversity Insights', 'Financial Strength Insights',
                            'Payment Insights', 'Third-Party Risk Insights'],
          :'Data Products' => ['Analytics', 'Company Profile', 'Corporate Linkage, Family Tree',
                              'Resolved Network Insights'],
          :'Company Report' => %w[pdf html txt]
        }.freeze

      ORDER_REASON_CODES =
        [{ 'Credit Decision': '6332' },
         { 'Assessment of credit solvency for intended business connection': 6333 },
         { 'Assessment of credit solvency for ongoing business connection': 6334 },
         { 'Debt Collection': 6335 },
         { 'Commercial Credit Insurance': 6336 },
         { 'Insurance Contract': 6337 },
         { 'Leasing Agreement': 6338 },
         { 'Rental Agreement': 6339 }].freeze

      private_constant :PRODUCT_COMPONENTS, :ORDER_REASON_CODES

      def self.products
        [:'Data Blocks', :'Data Products', :'Company Report']
      end

      def self.order_reasons
        [:'Credit Decision', :'Assessment of credit solvency for intended business connection',
         :'Assessment of credit solvency for ongoing business connection',
         :'Debt Collection', :'Commercial Credit Insurance', :'Insurance Contract',
         :'Leasing Agreement', :'Rental Agreement']
      end

      def initialize; end

      def product=(product)
        unless klass.products.include?(product)
          raise InvalidProduct, "#{product} is not in #{self.class.products}"
        end

        @product = product
      end

      def order_reason=(order_reason)
        unless klass.order_reasons.include?(order_reason)
          raise InvalidOrderReason, "#{order_reason} is not in #{self.class.order_reasons}"
        end

        @order_reason = order_reason
      end

      def product_components=(product_components)
        validate_product_components(product_components)

        @product_components = product_components
      end

      def customer_reference
        '965347174'
      end

      def to_s
        "productId=cmptcs&versionId=v1&tradeUp=hq&customerReference=#{customer_reference}&orderReason=6332&reportFormat=html"
      end

      private

      def klass
        self.class
      end

      def validate_product_components(product_components)
        message =
          if @product.nil?
            'Please set a product first'
          else
            validate_product_components_in_list(product_components)
          end
        if message.nil? && product != :'Data Blocks'
          message = validate_just_one_product_component(product_components)
        end

        raise InvalidProductComponents, message unless message.nil?
      end

      ##
      # Validate that all the required components
      # Exist in our list of all components
      def validate_product_components_in_list(product_components)
        return if (product_components - PRODUCT_COMPONENTS[product]).empty?

        "#{product_components} were not in the list of valid product components: "\
          "#{PRODUCT_COMPONENTS[:'Data Blocks']} for #{product}."
      end

      def validate_just_one_product_component(product_components)
        return if product_components.length == 1

        "Only one product component may be specified for #{product}."
      end
    end
  end
end
