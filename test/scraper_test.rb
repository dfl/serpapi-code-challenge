require_relative "test_helper"

require_relative "../lib/scraper"

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
      assert json = @scraper.to_json
      # assert_json_match json, JSON.parse(load_fixture("expected-array.json"))
    end

  end

end
