# frozen_string_literal: true

require 'bundler/setup' # Set up gems listed in the Gemfile.

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "empathy/emp_json"

require "minitest/autorun"
