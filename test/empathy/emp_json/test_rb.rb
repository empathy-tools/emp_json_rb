# frozen_string_literal: true

require "test_helper"

module Empathy
  module EmpJson
    class TestRb < Minitest::Test
      def test_that_it_has_a_version_number
        refute_nil ::Empathy::EmpJson::VERSION
      end
    end
  end
end
