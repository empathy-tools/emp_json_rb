# frozen_string_literal: true

module Empathy
  module EmpJson
    module Serializer
      # Module for serializing records to slices.
      module Serializing
        def render_emp_json(resource = @resource)
          Oj.fast_generate(emp_json_hash(resource))
        end

        def emp_json_hash(_resource = @resource)
          create_slice(@resource)
        end

        def create_slice(resources)
          slice = {}

          (resources.is_a?(Array) ? resources : [resources]).each do |resource|
            resource_to_emp_json(
              slice,
              @params,
              resource: resource,
              serializer_class: self.class,
              includes: @rdf_includes
            )
          end

          slice
        end

        def resource_to_emp_json(slice, serialization_params, **options) # rubocop:disable Metrics/AbcSize
          return if options[:resource].blank? || retrieve_id(options[:resource]).is_a?(Proc)

          if SUPPORTS_SEQUENCE && options[:resource].is_a?(LinkedRails::Sequence)
            add_sequence_to_slice(
              slice,
              serialization_params,
              **options
            )
          elsif SUPPORTS_RDF_RB && options[:resource].is_a?(RDF::List)
            add_rdf_list_to_slice(slice, symbolize, **options)
          else
            if options[:serializer_class] == RDF::Serializers::ListSerializer
              raise("Trying to serialize mixed resources")
            end

            serialize_record(
              slice,
              serialization_params,
              **options
            )
          end
        end
      end
    end
  end
end
