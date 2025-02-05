require_relative "../test_helper"

class ScraperTest < BaseTest
  context "a Scraper" do
    setup do
      @scraper = GoogleImageParser.new(load_fixture("van-gogh-paintings.html"))
    end
  
    should "parse html into doc" do
      assert @scraper.doc
    end

    should "have many images" do
      refute_empty @scraper.images
    end

    should "have nonce scripts" do
      refute_empty @scraper.nonce_scripts
    end

    should "output hash" do
      hash = @scraper.to_h
      assert hash
      assert_match %r{^data:image/jpeg}, hash[:artworks][0][:image]
      assert_match %r{google}, hash[:artworks][0][:link]
    end

    should "output json" do
      assert json = JSON.parse(@scraper.to_json)

      expected = JSON.parse(load_fixture("expected-array.json"))
      assert_equal json["artworks"].size, expected["artworks"].size

      assert_json_match pattern(json), json
    end

  end

  context "Klimt" do
    setup do
      @scraper = GoogleImageParser.new(load_fixture("klimt.html"))
    end

    should "output json" do
      assert json = JSON.parse(@scraper.to_json)
      assert_json_match pattern(json), json
    end
  end

  context "Georgia O'Keeffe" do
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
