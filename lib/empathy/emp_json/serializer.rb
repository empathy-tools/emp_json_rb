# frozen_string_literal: true

require_relative "serializer/fields"
require_relative "serializer/inclusion"
require_relative "serializer/records"
require_relative "serializer/sequence"
require_relative "serializer/serializing"

module Empathy
  module EmpJson
    # Module to use with the rdf-serializers gem.
    module Serializer
      extend ActiveSupport::Concern

      include Helpers::Primitives
      include Helpers::RDFList
      include Helpers::Slices
      include Helpers::Values
      include Fields
      include Inclusion
      include Records
      include Sequence
      include Serializing

      included do
        attr_accessor :symbolize
      end

      def initialize(resource, opts = {})
        self.symbolize = opts.delete(:symbolize)

        super
      end

      def dump(*args, **options)
        case args.first
        when :empjson
          render_emp_json
        else
          super(*args, **options)
        end
      end
    end
  end
end
