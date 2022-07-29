# frozen_string_literal: true

module Empathy
  module EmpJson
    module Helpers
      # Functions relating to serializing RDF::List records
      module RDFList
        def add_rdf_list_to_slice(slice, symbolize, **options)
          elem = options.delete(:resource)
          loop do
            list_item_to_record(slice, elem, symbolize)

            break if elem.rest_subject == RDF::RDFV.nil

            elem = elem.rest
          end
        end

        def list_item_to_record(slice, elem, symbolize)
          rid = add_record_to_slice(slice, elem)
          add_attribute_to_record(slice, rid, RDF::RDFV.type, RDF::RDFV.List, symbolize)
          first = elem.first.is_a?(RDF::Term) ? elem.first : retrieve_id(elem.first)
          add_attribute_to_record(slice, rid, RDF::RDFV.first, first, symbolize)
          add_attribute_to_record(slice, rid, RDF::RDFV.rest, elem.rest_subject, symbolize)
        end
      end
    end
  end
end
