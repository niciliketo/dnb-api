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
      product =  :'Data Blocks'
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

    def test_assign_more_than_one_product_component
      rt = Dnb::Api::ReportType.new
      product = :'Company Report'
      product_components = %w[pdf html]
      rt.product = product
      assert_raises Dnb::Api::InvalidProductComponents do
        rt.product_components = product_components
      end
    end
  end
end
