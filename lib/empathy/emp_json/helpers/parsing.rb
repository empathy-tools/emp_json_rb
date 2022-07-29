# frozen_string_literal: true

module Empathy
  module EmpJson
    module Helpers
      # Functions relating to parsing emp_json.
      module Parsing
        include Primitives

        def emp_to_primitive(emp_value) # rubocop:disable Metrics/MethodLength
          type = emp_value.with_indifferent_access[:type]
          value = emp_value.with_indifferent_access[:v]

          case type
          when EMP_TYPE_GLOBAL_ID
            RDF::URI(value)
          when EMP_TYPE_LOCAL_ID
            RDF::Node(value.split(":").last)
          when EMP_TYPE_DATE
            Date.iso8601(value)
          when EMP_TYPE_DATETIME
            Time.iso8601(value)
          when EMP_TYPE_BOOL
            value == "true"
          when EMP_TYPE_INTEGER, EMP_TYPE_LONG
            value.to_i
          when EMP_TYPE_PRIMITIVE
            use_rdf_rb_for_parsing(value, emp_value[:dt])
          when EMP_TYPE_STRING, EMP_TYPE_LANGSTRING
            value
          else
            throw_unknown_emp_type(type, value)
          end
        end

        def use_rdf_rb_for_parsing(value, datatype)
          RDF::Literal(value, datatype: datatype).object
        end

        def throw_unknown_emp_type(type, value)
          throw "unknown emp type: #{type} (#{value})"
        end
      end
    end
  end
end
