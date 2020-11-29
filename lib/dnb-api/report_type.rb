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
      attr_accessor :customer_reference
      attr_reader :order_reason, :product, :product_components, :product_sub_component

      # Some private constants
      PRODUCT_COMPONENTS =
        {
          'Data Blocks': ['Business Activity Insights', 'Derived Trade Insights', 'Hierarchies & Connections',
                          'Principals & Contacts', 'Company Financials', 'Filings & Events', 'Inquiry Insights',
                          'Sales & Marketing Insights', 'Company Information', 'External Disruption Insight',
                          'Ownership Insights', 'Shipping Insights', 'Spend Insights', 'Diversity Insights',
                          'Financial Strength Insights', 'Payment Insights', 'Third-Party Risk Insights'],
          'Data Products': ['Analytics', 'Company Profile', 'Corporate Linkage, Family Tree',
                            'Resolved Network Insights'],
          'Company Report': %w[pdf html txt]
        }.freeze

      PRODUCT_COMPONENT_CODES =
        {
          'Business Activity Insights' => 'businessactivityinsight',
          'Derived Trade Insights' => 'dtri',
          'Hierarchies & Connections' => 'hierarchyconnections',
          'Principals & Contacts' => 'principalscontacts',
          'Company Financials' => 'companyfinancials',
          'Filings & Events' => 'eventfilings',
          'Inquiry Insights' => 'inquiryinsight',
          'Sales & Marketing Insights' => 'salesmarketinginsight',
          'Company Information' => 'companyinfo',
          'External Disruption Insight' => 'externaldisruptioninsight',
          'Ownership Insights' => 'ownershipinsight',
          'Shipping Insights' => 'shippinginsight',
          'Spend Insights' => 'spendinsight',
          'Diversity Insights' => 'diversityinsight',
          'Financial Strength Insights' => 'financialstrengthinsight',
          'Payment Insights' => 'paymentinsight',
          'Third-Party Risk Insights' => 'thirdpartyriskinsight',
          'Analytics' => 'aasbig',
          'Company Profile' => { 'Trade Credit' => 'cmptcs',
                                 'Compliance Verification' => 'cmpcvf',
                                 'Executives, Linkage, and Financials' => 'cmpelf',
                                 'Linkage, and Executives v2' => 'cmpelkv2',
                                 'Linkage, and Executives v1' => 'cmpelkv1',
                                 'Financial Comparative Data' => 'cmpfcd',
                                 'Financial Market Data' => 'cmpfmd',
                                 'Linkage' => 'cmplnk',
                                 'Supplier Master Data Enrichment' => 'cmpsup',
                                 'Third Party Financials' => 'cmptpf',
                                 'Supplier Risk Assessment' => 'cmpsra',
                                 'Diversity Details' => 'cmpdve',
                                 'Diversity Indicator' => 'cmpdvs' },
          'Corporate Linkage' => { 'Alternate Linkage' => 'lnkalt',
                                   'Minority Linkage' => 'lnkmin',
                                   'Upward Corporate Linkage' => 'lnkupd',
                                   'Global Beneficial Ownership' => 'lnkgbo',
                                   'Family Tree, Full' => 'NOT YET IMPLEMENTED',
                                   'Family Tree, Upward' => 'NOT YET IMPLEMENTED'
                                 },
          'Family Tree' => 'NOT YET IMPLEMENTED',
          'Resolved Network Insights' => 'NOT YET IMPLEMENTED'
        }.freeze

      ORDER_REASON_CODES =
        [{ 'Credit Decision': 6332 },
         { 'Assessment of credit solvency for intended business connection': 6333 },
         { 'Assessment of credit solvency for ongoing business connection': 6334 },
         { 'Debt Collection': 6335 },
         { 'Commercial Credit Insurance': 6336 },
         { 'Insurance Contract': 6337 },
         { 'Leasing Agreement': 6338 },
         { 'Rental Agreement': 6339 }].freeze

      private_constant :PRODUCT_COMPONENTS, :ORDER_REASON_CODES, :PRODUCT_COMPONENT_CODES

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

      def product_sub_component=(product_sub_component)
        validate_product_sub_component(product_sub_component)
        @product_sub_component = product_sub_component
      end

      def valid?
        !product.nil? && !product_components.nil? && !order_reason.nil? &&
          !customer_reference.nil? && validate_product_sub_component_in_list?
      end

      def to_s
        raise InvalidReportType unless valid?
        "#{report_and_options_to_s}#{general_info_to_s}"
      end

      private

      def report_and_options_to_s
        case product
        when :'Data Blocks'
          data_blocks_to_s
        when :'Data Products'
          data_products_to_s
        when :'Company Report'
          company_report_to_s
        end
      end

      def data_blocks_to_s
        # TODO: The level should be configurable
        trail = '_L3_v1'
        join = "#{trail}%2C"
        blocks = product_components.collect { |component| PRODUCT_COMPONENT_CODES[component] }.join(join)
        "blockIDs=#{blocks}#{trail}"
      end

      def data_products_to_s
        if product_components == ['Company Profile']
          report = PRODUCT_COMPONENT_CODES[product_components.first][product_sub_component]
          "productId=#{report}&versionId=v1"
        else
          raise ReportTypeNotImplemented
        end
      end

      def company_report_to_s
        #TODO: birstd and comprh are available
        #TODO: languages are available
        "productId=comprh&inLanguage=en-US&reportFormat=#{product_components}"
      end

      def general_info_to_s
        "&tradeUp=hq&customerReference=#{customer_reference}&orderReason=#{order_reason}"
      end

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

      def validate_product_sub_component(product_sub_component)
        message =
          if @product_components.nil?
            'Please set a product component first'
          elsif !validate_product_sub_component_in_list?(product_sub_component)
            "#{product_sub_component} is not valid for #{product_components}"
          else
            nil
          end
        raise InvalidProductSubComponent, message unless message.nil?
      end

      def validate_product_sub_component_in_list?(product_sub_component = @product_sub_component)
        return true unless product.to_s == 'Data Products'
        product_component = product_components.first
        PRODUCT_COMPONENT_CODES[product_component].include?(product_sub_component)
      end
    end
  end
end
