require 'nokolexbor'

class GoogleImageParser
  attr_reader :doc

  def initialize filepath:
    html = File.open(filepath)
    @doc = Nokolexbor::HTML(html)
  end

end