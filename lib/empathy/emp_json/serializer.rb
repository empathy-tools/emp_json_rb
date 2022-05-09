# frozen_string_literal: true

require_relative "constants"
require_relative "base"
require_relative "inclusion"
require_relative "records"
require_relative "sequence"
require_relative "rdf_list"
require_relative "fields"
require_relative "slices"
require_relative "primitives"

module Empathy
  module EmpJson
    # Module to use with the rdf-serializers gem.
    module Serializer
      extend ActiveSupport::Concern

      include Constants
      include Base
      include Inclusion
      include Records
      include Sequence
      include RDFList
      include Fields
      include Slices
      include Primitives

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
