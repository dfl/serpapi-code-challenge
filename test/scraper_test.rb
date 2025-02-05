require_relative "test_helper"

require_relative "../lib/scraper"

class ScraperTest < Minitest::Test
  context "a Scraper" do
    setup do
      @scraper = GoogleImageParser.new(filepath: File.expand_path("../files/van-gogh-paintings.html", __dir__))
    end
    should "parse html into doc" do
      assert @scraper.doc 
    end
  end

end
