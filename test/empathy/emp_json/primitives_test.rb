# frozen_string_literal: true

require "test_helper"
require "active_model"
require "active_support/core_ext/time"
require "active_support/time_with_zone"
require "rdf/model/value"
require "rdf/model/term"
require "rdf/model/resource"
require "rdf/model/node"
require "rdf"

require_relative "../../../test/lib/linked_rails/model"
require_relative "../../../test/lib/linked_rails/sequence"

module Empathy
  module EmpJson
    class PrimitivesTest < Minitest::Test # rubocop:disable Metrics/ClassLength
      include Empathy::EmpJson::Helpers::Primitives

      class ClassValue; end # rubocop:disable Lint/EmptyClass

      class ClassWithIri
        class << self
          def iri
            URI("http://schema.org/MediaObject")
          end
        end
      end

      class SelfReferentialClass < RDF::Node
        include ActiveModel::Serialization
        include ActiveModel::Model
        include ::LinkedRails::Model

        def iri(**_opts)
          self
        end
      end

      def test_object_to_value_serializes_sequences
        value = LinkedRails::Sequence.new([], scope: false)
        exp = {
          type: "lid",
          v: "_:#{value.id.id}"
        }
        assert_equal exp, object_to_value(value)
      end

      def test_object_to_value_serializes_rdf__list
        value = RDF::List.new
        exp = {
          type: "id",
          v: "http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"
        }
        assert_equal exp, object_to_value(value.subject)
      end

      def test_object_to_value_serializes_resource_classes
        value = ClassWithIri
        exp = {
          type: "id",
          v: "http://schema.org/MediaObject"
        }
        assert_equal exp, object_to_value(value)
      end

      def test_primitive_to_value_serializes_global_id
        value = "https://example.com/foo"
        exp = {
          type: "id",
          v: value
        }
        assert_equal exp, primitive_to_value(RDF::URI(value))
        assert_equal exp, primitive_to_value(URI(value))
      end

      def test_primitive_to_value_serializes_local_id
        value = RDF::Node.new
        exp = {
          type: "lid",
          v: "_:#{value.id}"
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_serializes_symbols
        value = :symbolName
        exp = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#token",
          v: value.to_s
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_serializes_booleans
        truthy = true
        exp = {
          type: "b",
          v: "true"
        }
        assert_equal exp, primitive_to_value(truthy)

        falsy = false
        exp = {
          type: "b",
          v: "false"
        }
        assert_equal exp, primitive_to_value(falsy)
      end

      def test_primitive_to_value_serializes_strings
        value = "a string"
        exp = {
          type: "s",
          v: value
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_serializes_datetime
        value = Time.find_zone!("UTC").parse("2022-01-01T12:34Z")
        exp = {
          type: "dt",
          v: "2022-01-01T12:34:00Z"
        }
        assert_equal exp, primitive_to_value(value)

        # Perhaps this should be normalized to the same format
        value2 = DateTime.parse("2022-01-01T12:34Z")
        exp2 = {
          type: "dt",
          v: "2022-01-01T12:34:00+00:00"
        }
        assert_equal exp2, primitive_to_value(value2)
      end

      def test_primitive_to_value_serializes_numbers # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        int = 3
        exp = {
          type: "i",
          v: "3"
        }
        assert_equal exp, primitive_to_value(int)

        neg_int = -3
        exp = {
          type: "i",
          v: "-3"
        }
        assert_equal exp, primitive_to_value(neg_int)

        long = 3_000_000_000_000
        exp = {
          type: "l",
          v: "3000000000000"
        }
        assert_equal exp, primitive_to_value(long)

        bigint = 20_000_000_000_000_000_000
        exp = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#integer",
          v: "20000000000000000000"
        }
        assert_equal exp, primitive_to_value(bigint)

        big_decimal = BigDecimal("20.000000000000000001")
        exp = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#decimal",
          v: "20.000000000000000001"
        }
        assert_equal exp, primitive_to_value(big_decimal)

        float = 3.2
        exp = {
          type: "p",
          dt: "http://www.w3.org/2001/XMLSchema#double",
          v: "3.2"
        }
        assert_equal exp, primitive_to_value(float)
      end

      def test_primitive_to_value_serializes_langstring
        value = RDF::Literal("name", language: "en")
        exp = {
          type: "ls",
          l: "en",
          v: "name"
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_serializes_rdf_string
        value = RDF::Literal("name")
        exp = {
          type: "s",
          v: "name"
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_serializes_linkedrails__models_which_inherit_from_rdf__node
        value = SelfReferentialClass.new
        exp = {
          type: "lid",
          v: "_:#{value.id}"
        }
        assert_equal exp, primitive_to_value(value)
      end

      def test_primitive_to_value_throws_on_unknown_ruby_values
        assert_raises("unknown ruby object") do
          primitive_to_value(ClassValue)
        end
      end
    end
  end
end
