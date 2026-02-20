require "rubocop"

require_relative "rubocop/multiline_rhs_on_new_line/version"
require_relative "rubocop/cop/layout/multiline_rhs_on_new_line"

RuboCop::ConfigLoader.inject_defaults!(File.expand_path("../config/default.yml", __dir__))
