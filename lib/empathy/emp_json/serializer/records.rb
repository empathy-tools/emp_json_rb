# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/object/try"

module Empathy
  module EmpJson
    module Serializer
      # Functions relating to serializing records
      module Records
        def serialize_record(slice, serialization_params, **options)
          resource = options.delete(:resource)
          serializer = options.delete(:serializer_class) || RDF::Serializers.serializer_for(resource)

          rid = add_record_to_slice(slice, resource)

          nested = serialize_record_fields(serializer, slice, resource, rid, serialization_params)

          nested
            .reject { |r| slice_includes_record?(slice, r) }
            .each { |r| resource_to_emp_json(slice, serialization_params, resource: r) }
          process_includes(slice, serialization_params, resource: resource, **options) if options[:includes]
        end

        def serialize_record_fields(serializer, slice, resource, rid, serialization_params)
          nested = serialize_attributes_to_record(serializer, slice, resource, rid, serialization_params)
          nested += serialize_relations_to_record(serializer, slice, resource, rid, serialization_params)

          serialize_statements(serializer, slice, resource, serialization_params)

          nested
        end
      end
    end
  end
end
