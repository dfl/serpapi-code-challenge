require 'nokolexbor'
require 'json'

class GoogleImageParser
  attr_reader :doc

  def initialize(html, header: "Artworks" )
    @header = header
    @doc = Nokolexbor::HTML(html)
  end

  def to_json
    @json ||= self.to_h.to_json
  end

  def to_h
    @hash ||= { artworks: parse_images }
  end

  # private

  def images
    artworks = doc.xpath("//span[contains(text(), '#{@header}')]").last
    div = artworks.parent.parent.parent.parent.parent
    div.css("img")
  end
  
  def nonce_scripts    
    doc.css('script').select { |e| e['nonce'].to_s.strip != '' }
  end

  PLACEHOLDER = "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==".freeze

  def parse_images
    images.map do |element|
      unless image = element.attr('data-src')
        image = element.attr('src')
        if image == PLACEHOLDER 
          if image_id = element.attr('id')
            script = nonce_scripts.find{|e| e.text.include?(image_id)}
            if script&.text =~ /var s\s?=\s?['"](.*?)['"]/
              image = $1  # first capture group is the base64 string
              image.gsub!(/\\x([0-9A-Fa-f]+)/) { |match| [match[2..-1]].pack('H*') } # fancier version of image.gsub!("\\x3d","=")
            end
          end
        end
      end

      a = element.parent
      link = a.attr('href')
      link = "https://www.google.com#{link}" if link && link.start_with?('/')
      name, year = a.css("> div div").map(&:content).map(&:strip)
      name = name.split("\n").first
      output = {
        name:,
        link:,
        image:,
      }
      output[:extensions] = [year] if year
      output
    end
  end
end
