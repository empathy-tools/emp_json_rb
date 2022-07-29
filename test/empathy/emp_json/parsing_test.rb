# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/time"
require "active_support/time_with_zone"
require "rdf"

module Empathy
  module EmpJson
    class ParsingTest < Minitest::Test # rubocop:disable Metrics/ClassLength
      include Empathy::EmpJson::Helpers::Parsing

      def test_emp_to_primitive_parses_global_id
        exp = RDF::URI("https://example.com/foo")
        value = {
          type: "id",
          v: exp
        }
        assert_equal exp, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_local_id
        exp = RDF::Node.new
        value = {
          type: "lid",
          v: "_:#{exp.id}"
        }
        assert_equal exp, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_booleans
        truthy = true
        value = {
          type: "b",
          v: "true"
        }
        assert_equal truthy, emp_to_primitive(value)

        falsy = false
        value = {
          type: "b",
          v: "false"
        }
        assert_equal falsy, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_strings
        exp = "a string"
        value = {
          type: "s",
          v: exp
        }
        assert_equal exp, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_date
        value = {
          type: "date",
          v: "2022-01-01"
        }
        exp = Date.parse("2022-01-01")
        assert_equal exp, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_datetime
        value = {
          type: "dt",
          v: "2022-01-01T12:34:00Z"
        }
        exp = Time.find_zone!("UTC").parse("2022-01-01T12:34Z")
        assert_equal exp, emp_to_primitive(value)

        # Perhaps this should be normalized to the same format
        value2 = {
          type: "dt",
          v: "2022-01-01T12:34:00+00:00"
        }
        exp2 = DateTime.parse("2022-01-01T12:34Z")
        assert_equal exp2, emp_to_primitive(value2)
      end

      def test_emp_to_primitive_parses_numbers # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        int = 3
        value = {
          type: "i",
          v: "3"
        }
        assert_equal int, emp_to_primitive(value)

        neg_int = -3
        value = {
          type: "i",
          v: "-3"
        }
        assert_equal neg_int, emp_to_primitive(value)

        long = 3_000_000_000_000
        value = {
          type: "l",
          v: "3000000000000"
        }
        assert_equal long, emp_to_primitive(value)

        bigint = 20_000_000_000_000_000_000
        value = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#integer",
          v: "20000000000000000000"
        }
        assert_equal bigint, emp_to_primitive(value)

        big_decimal = BigDecimal("20.000000000000000001")
        value = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#decimal",
          v: "20.000000000000000001"
        }
        assert_equal big_decimal, emp_to_primitive(value)

        float = 3.2
        value = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#double",
          v: "3.2"
        }
        assert_equal float, emp_to_primitive(value)
      end

      def test_emp_to_primitive_parses_unknown_values
        value = {
          type: "x",
          v: "unknown"
        }

        assert_raises do
          emp_to_primitive(value)
        end
      end
    end
  end
end
