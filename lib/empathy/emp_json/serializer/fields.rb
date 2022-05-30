# frozen_string_literal: true

module Empathy
  module EmpJson
    module Serializer
      # Functions relating to serializing attributes, relations and statements
      module Fields
        # Modifies the record parameter
        def serialize_attributes_to_record(serializer, slice, resource, rid, serialization_params)
          return [] if serializer.attributes_to_serialize.blank?

          nested_resources = []
          serializer.attributes_to_serialize.each do |_, attr|
            next if attr.predicate.blank? || !attr.conditionally_allowed?(resource, serialization_params)

            value = value_for_attribute(attr, resource, serialization_params)
            symbol = predicate_to_symbol(attr)
            add_attribute_to_record(slice, rid, symbol, value, false)
            collect_nested_resources(nested_resources, slice, resource, value, serialization_params) if value.present?
          end

          nested_resources
        end

        # Modifies the slice parameter
        def serialize_statements(serializer, slice, resource, serialization_params)
          serializer._statements&.each do |key|
            serializer.send(key, resource, serialization_params).each do |statement|
              subject, predicate, value = unpack_statement(statement)

              next if value.nil?

              symbol = uri_to_symbol(predicate, symbolize)
              rid = add_record_to_slice(slice, subject)
              add_attribute_to_record(slice, rid, symbol, value, false)
            end
          end
        end

        # Modifies the record parameter
        def serialize_relations_to_record(serializer, slice, resource, rid, serialization_params)
          return [] if serializer.relationships_to_serialize.blank?

          nested_resources = []
          serializer.relationships_to_serialize.each do |_, relationship|
            next unless relationship.include_relationship?(resource, serialization_params)

            value = value_for_relation(relationship, resource, serialization_params)
            next if value.nil?

            symbol = predicate_to_symbol(relationship)
            add_attribute_to_record(slice, rid, symbol, value, false)

            collect_nested_resources(nested_resources, slice, resource, value, serialization_params)
          end

          nested_resources
        end

        def value_for_attribute(attr, resource, serialization_params)
          return resource.try(attr.method) if attr.method.is_a?(Symbol)

          FastJsonapi.call_proc(attr.method, resource, serialization_params)
        end

        def value_for_relation(relation, resource, serialization_params)
          value = unpack_relation_value(relation, resource, serialization_params)

          return if value.nil?

          if SUPPORTS_SEQUENCE && relation.sequence
            wrap_relation_in_sequence(value, resource)
          else
            value
          end
        end

        def unpack_relation_value(relation, resource, serialization_params)
          if relation.object_block
            FastJsonapi.call_proc(relation.object_block, resource, serialization_params)
          else
            resource.try(relation.key)
          end
        end

        def unpack_statement(statement)
          subject = statement.try(:subject) || statement[0]
          predicate = statement.try(:predicate) || statement[1]
          value = statement.try(:object) || statement[2]

          [subject, predicate, value]
        end

        def predicate_to_symbol(attr)
          return uri_to_symbol(attr.predicate, symbolize) if attr.predicate.present?

          attr.key
        end
      end
    end
  end
end
