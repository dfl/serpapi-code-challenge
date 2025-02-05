require "minitest/autorun"
require "minitest/rg"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require "shoulda-context"
require "json_expressions/minitest"

require "byebug"
require "amazing_print"

class BaseTest < Minitest::Test
  extend Shoulda::Context

  def load_fixture(filename)
    File.read(File.expand_path("fixtures/#{filename}", __dir__))
  end

end
