# frozen_string_literal: true

module Empathy
  module EmpJson
    module Serializer
      # Functions relating to serializing RDF::Sequence records
      module Sequence
        def add_sequence_to_slice(slice, serialization_params, **options)
          resource = options.delete(:resource)
          serializer = options[:serializer_class] || RDF::Serializers.serializer_for(resource)

          rid = add_record_to_slice(slice, resource)

          serialize_attributes_to_record(serializer, slice, resource, rid, serialization_params)
          process_sequence_members(serializer, slice, resource, rid, serialization_params, **options)
        end

        def process_sequence_members(serializer, slice, resource, rid, serialization_params, **options) # rubocop:disable Metrics/ParameterLists
          nested = []
          resource.members.each_with_index.map do |m, i|
            process_sequence_member(m, i, serializer, slice, resource, rid, serialization_params)
          end
          nested.each do |r|
            resource_to_emp_json(slice, serialization_params, resource: r, includes: options[:includes])
          end
        end

        def process_sequence_member(member, index, serializer, slice, resource, rid, serialization_params) # rubocop:disable Metrics/ParameterLists
          index_predicate = serializer.relationships_to_serialize[:members].predicate
          symbol = uri_to_symbol(index_predicate.call(self, index), symbolize)
          slice[rid][symbol] = value_to_emp_value(member)
          collect_nested_resources(nested, slice, resource, member, serialization_params)
        end
      end
    end
  end
end
