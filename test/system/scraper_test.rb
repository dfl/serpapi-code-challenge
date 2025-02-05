require_relative "../test_helper"

require 'ferrum'

class ScraperTest < BaseTest
  context "Klimt" do
    setup do
      @scraper = GoogleImageParser.new(load_fixture("klimt.html"))
    end

    should "output json" do
      assert json = JSON.parse(@scraper.to_json)
      assert_json_match pattern(json), json
    end
  end

  context "Georgia O'Keefe" do
    setup do
      @scraper = GoogleImageParser.new(load_fixture("okeeffe.html"))
    end

    should "output json" do
      assert json = JSON.parse(@scraper.to_json)
      assert_json_match pattern(json), json
    end
  end


  def pattern(json)
  {
      artworks: [
        {
          name: String,
          extensions: wildcard_matcher,
          link: /^https:\/\/www\.google\.com\//,  # Matches the 'link' URL pattern
          image: String #/https:\/\/encrypted-tbn\d\.gstatic\.com\/images\?q=tbn:/  # Matches the 'image' URL pattern
        }
      ] * json["artworks"].size
    }
  end

end
