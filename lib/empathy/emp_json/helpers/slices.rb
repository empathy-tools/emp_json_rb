# frozen_string_literal: true

module Empathy
  module EmpJson
    module Helpers
      # Additional functions for working with slices
      module Slices
        # Retrieves all values for the given [field].
        def all_values_from_slice(slice, field, _website_iri = nil)
          slice
            .values
            .flat_map { |record| field_from_record(record, field) }
            .map { |values| normalise_slice_values(values) }
            .compact
        end

        # Returns a normalised fields array for a record from a slice.
        def values_from_slice(slice, id, field, website_iri = nil)
          values = field_from_slice(slice, id, field, website_iri)

          normalise_slice_values(values)
        end

        # Returns the fields for a record from a slice.
        def field_from_slice(slice, id, field, website_iri = nil)
          record = record_from_slice(slice, id, website_iri)
          return unless record.present?

          field_from_record(record, field)
        end

        # Returns a record from a slice.
        def record_from_slice(slice, id, website_iri = nil)
          slice[absolutized_id(retrieve_id(id), website_iri)] || slice[retrieve_id(id)]
        end

        def field_from_record(record, field)
          field = URI(field.to_s)
          symbolized = (field.fragment || field.path.split("/").last).camelize(:lower)
          (record[field.to_s] || record[symbolized])&.compact
        end

        def retrieve_id(id)
          id.try(:iri) || id
        end

        def absolutized_id(id, website_iri = nil)
          return id.to_s.delete_prefix(website_iri) if website_iri.present?

          id.to_s
        end

        def normalise_slice_values(values)
          values.is_a?(Array) ? values.map(&:with_indifferent_access) : values&.with_indifferent_access
        end

        def expand(slice, website_iri = current_tenant)
          return slice unless website_iri.present?

          slice.transform_keys { |k| k.start_with?("/") ? website_iri + k : k }
        end

        def field_to_symbol(uri)
          (uri.fragment || uri.path.split("/").last).camelize(:lower)
        end
      end
    end
  end
end
