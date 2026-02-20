require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require "rubocop-multiline_rhs_on_new_line"

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense
end
