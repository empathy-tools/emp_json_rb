# frozen_string_literal: true

module Empathy
  module EmpJson
    # Module for serializing records to slices.
    module Slices
      include Constants

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

      def resource_to_emp_json(slice, serialization_params, **options)
        return if options[:resource].blank? || record_id(options[:resource]).is_a?(Proc)

        if SUPPORTS_SEQUENCE && options[:resource].is_a?(SEQUENCE_CLASS)
          add_sequence_to_slice(
            slice,
            serialization_params,
            **options
          )
        elsif SUPPORTS_RDF_RB && options[:resource].is_a?(LIST_CLASS)
          add_rdf_list_to_slice(slice, **options)
        else
          raise("Trying to serialize mixed resources") if options[:serializer_class] == RDF::Serializers::ListSerializer

          add_record_to_slice(
            slice,
            serialization_params,
            **options
          )
        end
      end
    end
  end
end
