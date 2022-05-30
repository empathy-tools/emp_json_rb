# frozen_string_literal: true

require "active_support"
require "test_helper"
require "rdf"

module Empathy
  module EmpJson
    class HelpersTest < Minitest::Test
      include ::Empathy::EmpJson::Helpers::Slices
      include ::Empathy::EmpJson::Helpers::Primitives
      include ::Empathy::EmpJson::Helpers::Values

      Model = Struct.new(:iri)

      def test_record_from_slice
        slice = {}

        id = RDF::URI("https://example.com/record/1")
        key = RDF::URI("https://example.com/foo/bar")
        value = 1
        exp = {
          _id: {
            type: "id",
            v: id.to_s
          },
          "https://example.com/foo/bar" => {
            type: "i",
            v: "1"
          }
        }

        add_record_to_slice(slice, Model.new(id))
        add_attribute_to_record(slice, id.to_s, key, value, false)

        assert_equal(record_from_slice(slice, id), exp)
      end

      def test_record_from_slice_symbolize
        slice = {}

        id = RDF::URI("https://example.com/record/1")
        key = RDF::URI("https://example.com/fooBar")
        value = 1
        exp = {
          _id: {
            type: "id",
            v: id.to_s
          },
          "fooBar" => {
            type: "i",
            v: "1"
          }
        }

        add_record_to_slice(slice, Model.new(id))
        add_attribute_to_record(slice, id.to_s, key, value, true)

        assert_equal(record_from_slice(slice, id), exp)
      end

      def test_record_from_slice_symbolize_class
        slice = {}

        id = RDF::URI("https://example.com/record/1")
        key = RDF::URI("https://example.com/fooBar")
        value = 1
        exp = {
          _id: {
            type: "id",
            v: id.to_s
          },
          "FooBar" => {
            type: "i",
            v: "1"
          }
        }

        add_record_to_slice(slice, Model.new(id))
        add_attribute_to_record(slice, id.to_s, key, value, :class)

        assert_equal(record_from_slice(slice, id), exp)
      end

      def test_values_from_slice
        slice = {}

        id = RDF::URI("https://example.com/record/1")
        key = RDF::URI("https://example.com/foo/bar")
        value = 1

        add_record_to_slice(slice, Model.new(id))
        add_attribute_to_record(slice, id.to_s, key, value, false)

        assert_equal(values_from_slice(slice, id, key), primitive_to_value(1).with_indifferent_access)
      end
    end
  end
end
