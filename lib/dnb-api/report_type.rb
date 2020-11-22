# frozen_string_literal: true

##
# Outer namespace to Dnb::API
module Dnb
  ##
  # Inner namespace to Dnb::API
  module Api
    ##
    # Class to describe the different report types available
    # for a company

    class ReportType
      attr_accessor :order_reason, :report_product, :report_product_components
      def self.report_products
        ['Data Blocks', 'Data Products', 'Company Report']
      end

      def self.report_product_components
        {'Data Blocks' => ['Business Activity Insights', 'Derived Trade Insights', 'Hierarchies & Connections', 'Principals & Contacts',
                          'Company Financials', 'Filings & Events', 'Inquiry Insights', 'Sales & Marketing Insights',
                        'Company Information', 'External Disruption Insight', 'Ownership Insights', 'Spend Insights',
                        'Diversity Insights', 'Financial Strength Insights', 'Payment Insights', 'Third-Party Risk Insights'],
         'Data Products' => ['Analytics', 'Company Profile', 'Corporate Linkage, Family Tree', 'Resolved Network Insights'],
         'Company Report'=> ['pdf', 'html', 'txt']
        }
      end

      def self.order_reasons
        [{ 'Credit Decision' => 6332 },
         { 'Assessment of credit solvency for intended business connection' => 6333 },
         { 'Assessment of credit solvency for ongoing business connection' => 6334 },
         { 'Debt Collection' => 6335 },
         { 'Commercial Credit Insurance' => 6336 },
         { 'Insurance Contract' =>  6337 },
         { 'Leasing Agreement' => 6338 },
         { 'Rental Agreement' => 6339 }]
      end
      def initialize; end

      def order_reason

      end

      def customer_reference
        '965347174'
      end

      def to_s
        "productId=cmptcs&versionId=v1&tradeUp=hq&customerReference=#{customer_reference}&orderReason=6332&reportFormat=html"
      end

    end
  end
end
