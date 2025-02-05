require 'nokolexbor'
require 'json'

class GoogleImageParser
  attr_reader :doc

  def initialize(html)
    @doc = Nokolexbor::HTML(html)
  end

  # doc.css("img.taFGZJe")
  # .taFZJe{flex-grow:1;object-fit:contain;max-height:350px;width:100%}
  # 
  def to_json
    @json ||= self.to_h.to_json
  end

  def to_h
    @hash ||= { artworks: parse_images }
  end

  # private

  def images
    artworks = doc.xpath("//span[contains(text(), 'Artworks')]").last
    div = artworks.parent.parent.parent.parent.parent
    div.css("img")
  end
  
  def nonce_scripts    
    doc.css('script').select { |e| e['nonce'].to_s.strip != '' }
  end

  def parse_images
    images.map do |element|

      unless image = element.attr('data-src')
        if image_id = element.attr('id')
          script = nonce_scripts.find{|e| e.text.include?(image_id)}
          if script&.text =~ /var s=['"](.*?)['"]/
            image = $1  # first capture group is the base64 string
            image.gsub!(/\\x([0-9A-Fa-f]+)/) { |match| [match[2..-1]].pack('H*') } # fancier version of image.gsub!("\\x3d","=")
          end
        end
      end

      link = element.parent.attr('href')
      link = "https://www.google.com#{link}" if link && link.start_with?('/')

      div = element.next_sibling
      name, year = div.css("div").map(&:content)
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
