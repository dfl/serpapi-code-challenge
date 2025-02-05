require_relative "../test_helper"

require 'ferrum'

class ScraperTest < BaseTest
  context "Klimt" do
    setup do
      # @browser = init_browser
      # @browser.go_to("https://www.google.com/search?q=gustav+klimt+artworks")
      # @browser.network.wait_for_idle
      # html = @browser.body

      # File.write("test/fixtures/klimt.html", html)
      @scraper = GoogleImageParser.new(load_fixture("klimt.html"))
    end

    should "output json" do
      assert json = JSON.parse(@scraper.to_json)
      puts json
      pattern = {
        artworks: [
          {
            name: String,
            extensions: wildcard_matcher,
            link: /^https:\/\/www\.google\.com\//,  # Matches the 'link' URL pattern
            image: String #/https:\/\/encrypted-tbn\d\.gstatic\.com\/images\?q=tbn:/  # Matches the 'image' URL pattern
          }
        ] * json["artworks"].size
      }

      assert_json_match pattern, json
    end

    # should "fetch google images" do
    #   p output = @scraper.to_h
    #   assert output
    # end  

    # teardown do
    #   @browser.quit
    # end
  end


  def init_browser
    # https://railsnotes.xyz/blog/ferrum-stealth-browsing
    headers = {
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "Accept-Encoding" => "gzip, deflate, br, zstd",
      "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
      "Cache-Control" => "no-cache",
      "Pragma" => "no-cache",
      "Priority" => "u=0, i",
      "Sec-Ch-Ua" => '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
      "Sec-Ch-Ua-Mobile" => "?0",
      "Sec-Ch-Ua-Platform" => "\"macOS\"",
      "Sec-Fetch-Dest" => "document",
      "Sec-Fetch-Mode" => "navigate",
      "Sec-Fetch-Site" => "cross-site",
      "Sec-Fetch-User" => "?1",
      "Upgrade-Insecure-Requests" => "1",
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    }

    # Hide automation flag and adjust default window size to be less common
    opts = {
      headless: "new",
      timeout: 35,
      window_size: [1366, 768],
      browser_options: {
        "disable-blink-features" => "AutomationControlled"
        },
      extensions: [Pathname.new("./stealth.min.js").expand_path]
    }

    browser = Ferrum::Browser.new(opts)
    browser.headers.set(headers)
    browser
  end
end
