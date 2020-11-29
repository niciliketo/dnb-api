# frozen_string_literal: true

require 'minitest/autorun'
require 'dnb-api'
require 'vcr'
module Dnb
  # Test the real version of the API
  class ReportTypeTest < Minitest::Test
    def setup
      Dnb::Api.logger.level = Logger::INFO
    end

    def test_products_enumerator
      assert_equal 3, Dnb::Api::ReportType.products.length, 'Wrong number of products'
    end

    def test_order_reasons_enumerator
      assert_equal 8, Dnb::Api::ReportType.order_reasons.length, 'Wrong number of order reasons'
    end

    def test_assign_valid_product
      rt = Dnb::Api::ReportType.new
      product =  :'Data Blocks'
      rt.product = product
      assert_equal product, rt.product
    end

    def test_assign_invalid_product
      rt = Dnb::Api::ReportType.new
      assert_raises Dnb::Api::InvalidProduct do
        rt.product = :'Something Awful'
      end
    end

    def test_assign_valid_order_reason
      rt = Dnb::Api::ReportType.new
      order_reason =  :'Credit Decision'
      rt.order_reason = order_reason
      assert_equal order_reason, rt.order_reason
    end

    def test_assign_invalid_order_reason
      rt = Dnb::Api::ReportType.new
      assert_raises Dnb::Api::InvalidOrderReason do
        rt.order_reason = :'Something Awful'
      end
    end

    def test_assign_valid_product_components
      rt = Dnb::Api::ReportType.new
      product = :'Data Blocks'
      product_components = ['Business Activity Insights', 'Derived Trade Insights']
      rt.product = product
      rt.product_components = product_components
      assert_equal product_components, rt.product_components
    end

    def test_assign_invalid_product_components
      rt = Dnb::Api::ReportType.new
      product = :'Data Blocks'
      product_components = ['Something awful', 'Something dreadful']
      rt.product = product
      assert_raises Dnb::Api::InvalidProductComponents do
        rt.product_components = product_components
      end
    end

    def test_assign_valid_product_sub_component
      rt = Dnb::Api::ReportType.new
      product = :'Data Products'
      product_components = ['Company Profile']
      product_sub_component = 'Trade Credit'
      rt.product = product
      rt.product_components = product_components
      rt.product_sub_component = product_sub_component
      assert_equal product_sub_component, rt.product_sub_component
    end

    def test_assign_invalid_product_sub_component
      rt = Dnb::Api::ReportType.new
      product = :'Data Products'
      product_components = ['Company Profile']
      product_sub_component = 'Something Awful'
      rt.product = product
      rt.product_components = product_components
      assert_raises Dnb::Api::InvalidProductSubComponent do
        rt.product_sub_component = product_sub_component
      end
    end

    def test_assign_more_than_one_product_component
      rt = Dnb::Api::ReportType.new
      product = :'Company Report'
      product_components = %w[pdf html]
      rt.product = product
      assert_raises Dnb::Api::InvalidProductComponents do
        rt.product_components = product_components
      end
    end

    def test_valid_false
      rt = Dnb::Api::ReportType.new
      assert_equal false, rt.valid?
    end

    def test_valid_true
      rt = Dnb::Api::ReportType.new
      product = :'Data Blocks'
      product_components = ['Business Activity Insights', 'Derived Trade Insights']
      rt.product = product
      rt.product_components = product_components
      rt.order_reason = :'Credit Decision'
      rt.customer_reference = '12345'
      assert_equal true, rt.valid?
    end

    def test_to_s_on_invalid_report_type_raises_exception
      rt = Dnb::Api::ReportType.new
      assert_raises Dnb::Api::InvalidReportType do
        puts rt.to_s
      end
    end

    def test_to_s_on_data_blocks
      rt = Dnb::Api::ReportType.new
      product = :'Data Blocks'
      product_components = ['Business Activity Insights', 'Derived Trade Insights']
      rt.product = product
      rt.product_components = product_components
      rt.order_reason = :'Credit Decision'
      rt.customer_reference = '12345'
      expected = 'blockIDs=businessactivityinsight_L3_v1%2Cdtri_L3_v1'\
                 '&tradeUp=hq&customerReference=12345&orderReason=Credit Decision'
      assert_equal expected, rt.to_s
    end

    def test_to_s_on_company_profile
      rt = Dnb::Api::ReportType.new
      product = :'Data Products'
      product_components = ['Company Profile']
      product_sub_component = 'Trade Credit'
      rt.product = product
      rt.product_components = product_components
      rt.product_sub_component = product_sub_component
      rt.order_reason = :'Credit Decision'
      rt.customer_reference = '12345'
      expected = 'productId=cmptcs&versionId=v1'\
                '&tradeUp=hq&customerReference=12345&orderReason=Credit Decision'
      assert_equal expected, rt.to_s
    end
  end
end
