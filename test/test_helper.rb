require "minitest/autorun"
require "minitest/rg"
require "minitest/reporters"

require "shoulda-context"

# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class BaseTest < Minitest::Test
  extend Shoulda::Context
end
