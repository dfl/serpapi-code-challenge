require "minitest/autorun"
require "minitest/rg"
require "minitest/reporters"
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require "shoulda-context"

class BaseTest < Minitest::Test
  extend Shoulda::Context
end
