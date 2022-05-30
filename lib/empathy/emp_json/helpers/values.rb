# frozen_string_literal: true

module Empathy
  module EmpJson
    module Helpers
      # Functions relating to adding values to records
      module Values
        include Helpers::Constants

        def add_attribute_to_record(slice, rid, key, value, symbolize)
          return if value.nil?

          symbol = symbolize ? uri_to_symbol(key, symbolize) : key.to_s
          emp_value = value_to_emp_value(value)
          current_value = slice[rid][symbol]

          slice[rid][symbol] =
            if current_value.is_a?(Array)
              [*current_value, *(emp_value.is_a?(Array) ? emp_value : [emp_value])]
            elsif current_value
              [current_value, *(emp_value.is_a?(Array) ? emp_value : [emp_value])]
            else
              emp_value
            end
        end

        def wrap_relation_in_sequence(value, resource)
          SEQUENCE_CLASS.new(
            value.is_a?(Array) ? value : [value],
            parent: resource,
            scope: false
          )
        end

        def uri_to_symbol(uri, symbolize)
          casing = symbolize == :class ? :upper : :lower

          (uri.fragment || uri.path.split("/").last).camelize(casing)
        end

        def value_to_emp_value(value)
          case value
          when nil
            object_to_value(value)
          when SEQUENCE_CLASS
            object_to_value(value.iri)
          when LIST_CLASS
            object_to_value(value.subject)
          when Array, *AR_ASSOCIATION_CLASSES
            value.map { |v| object_to_value(v) }.compact
          else
            object_to_value(value)
          end
        end
      end
    end
  end
end
