# frozen_string_literal: true

module Empathy
  module EmpJson
    # Defines constants used in EmpJson serialization
    module Constants
      EMP_TYPE_GLOBAL_ID = "id"
      EMP_TYPE_LOCAL_ID = "lid"
      EMP_TYPE_DATETIME = "dt"
      EMP_TYPE_STRING = "s"
      EMP_TYPE_BOOL = "b"
      EMP_TYPE_INTEGER = "i"
      EMP_TYPE_LONG = "l"
      EMP_TYPE_PRIMITIVE = "p"
      EMP_TYPE_LANGSTRING = "ls"

      RDF_RDFV = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
      RDF_RDFV_LANGSTRING = "#{RDF_RDFV}langString"
      RDF_RDFS = "http://www.w3.org/2000/01/rdf-schema#"
      RDF_XSD = "http://www.w3.org/2001/XMLSchema#"
      RDF_XSD_TOKEN = "#{RDF_XSD}token"
      RDF_XSD_STRING = "#{RDF_XSD}string"
      RDF_XSD_DATETIME = "#{RDF_XSD}dateTime"
      RDF_XSD_BOOLEAN = "#{RDF_XSD}boolean"
      RDF_XSD_INTEGER = "#{RDF_XSD}integer"

      SUPPORTS_RDF_RB = Object.const_defined?("RDF")
      LIST_CLASS = SUPPORTS_RDF_RB ? Object.const_get("RDF::List") : nil
      SUPPORTS_SEQUENCE = Object.const_defined?("LinkedRails")
      SEQUENCE_CLASS = SUPPORTS_SEQUENCE ? Object.const_get("LinkedRails::Sequence") : nil
    end
  end
end
