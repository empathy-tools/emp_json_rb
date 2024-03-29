# frozen_string_literal: true

require "active_support/time_with_zone"

module Empathy
  module EmpJson
    module Helpers
      # Functions relating to serializing primitives.
      module Primitives # rubocop:disable Metrics/ModuleLength
        EMP_TYPE_GLOBAL_ID = "id"
        EMP_TYPE_LOCAL_ID = "lid"
        EMP_TYPE_DATE = "date"
        EMP_TYPE_DATETIME = "dt"
        EMP_TYPE_STRING = "s"
        EMP_TYPE_BOOL = "b"
        EMP_TYPE_INTEGER = "i"
        EMP_TYPE_DOUBLE = "d"
        EMP_TYPE_LONG = "l"
        EMP_TYPE_PRIMITIVE = "p"
        EMP_TYPE_LANGSTRING = "ls"

        RDF_RDFV = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        RDF_RDFV_LANGSTRING = "#{RDF_RDFV}langString"
        RDF_RDFS = "http://www.w3.org/2000/01/rdf-schema#"
        RDF_XSD = "http://www.w3.org/2001/XMLSchema#"
        RDF_XSD_TOKEN = "#{RDF_XSD}token"
        RDF_XSD_STRING = "#{RDF_XSD}string"
        RDF_XSD_DATE = "#{RDF_XSD}date"
        RDF_XSD_DATETIME = "#{RDF_XSD}dateTime"
        RDF_XSD_BOOLEAN = "#{RDF_XSD}boolean"
        RDF_XSD_INTEGER = "#{RDF_XSD}integer"
        RDF_XSD_FLOAT = "#{RDF_XSD}float"
        RDF_XSD_DOUBLE = "#{RDF_XSD}double"
        RDF_XSD_DECIMAL = "#{RDF_XSD}decimal"

        def object_to_value(value)
          return primitive_to_value(value.iri) if value.respond_to?(:iri)

          return primitive_to_value(value.subject) if value.is_a?(RDF::List)

          primitive_to_value(value)
        end

        def node_to_local_id(value)
          shorthand(EMP_TYPE_LOCAL_ID, "_:#{value.id}")
        end

        def primitive_to_value(value) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
          throw_unknown_ruby_object(value) if value.nil?

          case value
          when RDF::Node
            node_to_local_id(value)
          when RDF::URI, URI
            shorthand(EMP_TYPE_GLOBAL_ID, value.to_s)
          when DateTime, ActiveSupport::TimeWithZone
            shorthand(EMP_TYPE_DATETIME, value.iso8601)
          when Date
            shorthand(EMP_TYPE_DATE, value.iso8601)
          when String, Symbol
            shorthand(EMP_TYPE_STRING, value.to_s)
          when true, false
            shorthand(EMP_TYPE_BOOL, value.to_s)
          when Integer
            integer_to_value(value)
          when Float
            shorthand(EMP_TYPE_DOUBLE, value.to_s)
          when Numeric
            use_rdf_rb_for_primitive(value)
          when RDF::Literal
            rdf_literal_to_value(value)
          else
            throw_unknown_ruby_object(value)
          end
        end

        def integer_to_value(value)
          size = value.bit_length
          if size <= 32
            shorthand(EMP_TYPE_INTEGER, value.to_s)
          elsif size > 32 && size <= 64
            shorthand(EMP_TYPE_LONG, value.to_s)
          else
            use_rdf_rb_for_primitive(value)
          end
        end

        def rdf_literal_to_value(value) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          case value.datatype.to_s
          when RDF_RDFV_LANGSTRING
            {
              type: EMP_TYPE_LANGSTRING,
              l: value.language.to_s,
              v: value.value
            }
          when RDF_XSD_STRING, RDF_XSD_TOKEN
            shorthand(EMP_TYPE_STRING, value.value)
          when RDF_XSD_DATE
            shorthand(EMP_TYPE_DATE, value.value)
          when RDF_XSD_DATETIME
            shorthand(EMP_TYPE_DATETIME, value.value)
          when RDF_XSD_BOOLEAN
            shorthand(EMP_TYPE_BOOL, value.value)
          when RDF_XSD_DOUBLE
            shorthand(EMP_TYPE_DOUBLE, value.value)
          when RDF_XSD_DECIMAL, RDF_XSD_FLOAT
            primitive(value.datatype.to_s, value.value)
          when RDF_XSD_INTEGER
            integer_to_value(value.to_i)
          else
            throw "unknown RDF::Literal: #{value.datatype}"
          end
        end

        def use_rdf_rb_for_primitive(value)
          rdf = RDF::Literal(value)
          primitive(rdf.datatype.to_s, rdf.value)
        end

        def shorthand(type, value)
          {
            type: type,
            v: value
          }
        end

        def primitive(datatype, value)
          {
            type: EMP_TYPE_PRIMITIVE,
            dt: datatype,
            v: value
          }
        end

        def throw_unknown_ruby_object(value)
          throw "unknown ruby object: #{value} (#{value.class})"
        end
      end
    end
  end
end
