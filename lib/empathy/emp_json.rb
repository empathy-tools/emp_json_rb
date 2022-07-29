# frozen_string_literal: true

require "empathy/emp_json/helpers/primitives"
require "empathy/emp_json/helpers/rdf_list"
require "empathy/emp_json/helpers/slices"
require "empathy/emp_json/helpers/values"
require "empathy/emp_json/helpers/parsing"
require "empathy/emp_json/serializer"

module Empathy
  module EmpJson
    SUPPORTS_RDF_RB = Object.const_defined?("RDF")
    SUPPORTS_SEQUENCE = Object.const_defined?("LinkedRails")
    SUPPORTS_AR = Object.const_defined?("ActiveRecord")

    class Error < StandardError; end
  end
end
