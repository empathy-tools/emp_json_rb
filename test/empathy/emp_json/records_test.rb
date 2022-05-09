# frozen_string_literal: true

require "active_support"
require "test_helper"
require "rdf"
require "empathy/emp_json/records"
require "empathy/emp_json/primitives"

module Empathy
  module EmpJson
    class RecordsTest < Minitest::Test
      include ::Empathy::EmpJson::Records
      include ::Empathy::EmpJson::Primitives

      Model = Struct.new(:iri)

      def test_record_id_handles_uri
        value = URI("https://example.com/bar")

        assert_equal "https://example.com/bar", record_id(value)
      end

      def test_create_record_initialises_global_id
        id = RDF::URI("https://example.com/foo")
        slice = {}
        exp = {
          _id: {
            type: "id",
            v: id.to_s
          }
        }
        create_record(slice, Model.new(id))

        assert_equal exp, slice[id.to_s]
      end

      def test_create_record_initialises_local_id
        id = RDF::Node.new
        slice = {}
        exp = {
          _id: {
            type: "lid",
            v: "_:#{id.id}"
          }
        }
        create_record(slice, Model.new(id))

        assert_equal exp, slice[id.to_s]
      end
    end
  end
end
