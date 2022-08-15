# frozen_string_literal: true

require "empathy/emp_json/helpers/primitives"
require "empathy/emp_json/helpers/rdf_list"
require "empathy/emp_json/helpers/slices"
require "empathy/emp_json/helpers/values"
require "empathy/emp_json/helpers/parsing"
require "empathy/emp_json/helpers/hash"
require "empathy/emp_json/serializer"

module Empathy
  module EmpJson
    # Class for checking if certain gems are present
    class SupportChecker
      class << self
        def check(gem)
          require gem
          true
        rescue LoadError
          false
        end
      end
    end

    SUPPORTS_RDF_RB = SupportChecker.check("rdf")
    SUPPORTS_SEQUENCE = SupportChecker.check("linked_rails")
    SUPPORTS_AR = SupportChecker.check("active_record")

    class Error < StandardError; end
  end
end
