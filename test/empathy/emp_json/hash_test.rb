# frozen_string_literal: true

require "test_helper"
require "rdf"

module Empathy
  module EmpJson
    class ParsingTest < Minitest::Test # rubocop:disable Metrics/ClassLength
      def test_hash_to_emp_json_named_record
        value = {
          RDF::URI("https://example.com") => {}
        }
        exp = {
          "https://example.com" => {
            "_id" => {
              type: "id",
              v: "https://example.com"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_blank_record
        value = {
          RDF::Node.new("a") => {}
        }
        exp = {
          "_:a" => {
            "_id" => {
              type: "lid",
              v: "_:a"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_multiple_records
        value = {
          RDF::URI("https://example.com/1") => {},
          RDF::URI("https://example.com/2") => {}
        }
        exp = {
          "https://example.com/1" => {
            "_id" => {
              type: "id",
              v: "https://example.com/1"
            }
          },
          "https://example.com/2" => {
            "_id" => {
              type: "id",
              v: "https://example.com/2"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_iri_key
        value = {
          "." => {
            RDF.type => "Record"
          }
        }
        exp = {
          "." => {
            "_id" => {
              type: "s",
              v: "."
            },
            RDF.type.to_s => {
              type: "s",
              v: "Record"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_string_key
        value = {
          "." => {
            RDF.type.to_s => "Record"
          }
        }
        exp = {
          "." => {
            "_id" => {
              type: "s",
              v: "."
            },
            RDF.type.to_s => {
              type: "s",
              v: "Record"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_with_integer
        value = {
          RDF::URI("https://example.com") => {
            key: 1
          }
        }
        exp = {
          "https://example.com" => {
            "key" => {
              type: "i",
              v: "1"
            },
            "_id" => {
              type: "id",
              v: "https://example.com"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end

      def test_hash_to_emp_json_with_integer_array # rubocop:disable Metrics/MethodLength
        value = {
          RDF::URI("https://example.com") => {
            key: [1, 2]
          }
        }
        exp = {
          "https://example.com" => {
            "key" => [
              {
                type: "i",
                v: "1"
              },
              {
                type: "i",
                v: "2"
              }
            ],
            "_id" => {
              type: "id",
              v: "https://example.com"
            }
          }
        }
        assert_equal exp, value.to_emp_json
      end
    end
  end
end
