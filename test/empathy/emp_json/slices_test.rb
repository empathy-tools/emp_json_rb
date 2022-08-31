# frozen_string_literal: true

require "active_support"
require "test_helper"
require "rdf"

module Empathy
  module EmpJson
    class SlicesTest < Minitest::Test
      include ::Empathy::EmpJson::Helpers::Slices
      include ::Empathy::EmpJson::Helpers::Primitives

      Model = Struct.new(:iri)

      def test_record_id_handles_uri
        id = URI("https://example.com/foo")
        slice = {}
        exp = {
          _id: {
            type: "id",
            v: id.to_s
          }
        }
        add_record_to_slice(slice, URI("https://example.com/foo"))

        assert_equal exp, slice[id.to_s]
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
        add_record_to_slice(slice, Model.new(id))

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
        add_record_to_slice(slice, Model.new(id))

        assert_equal exp, slice[id.to_s]
      end
    end
  end
end
