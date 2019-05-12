require 'json'
require 'open-uri'
require 'mini_magick'
require 'net/http'
require 'nokogiri'

def get_image_urls(url)
  puts "[start] get_image_urls"
  charset = 'utf-8'

  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  image_urls = []
  if url.match(/\Ahttps:\/\/item.mercari.com/)
    image_urls = get_mercari_image_urls(doc)
  end

  image_urls.each do |image_url|
    download_image(image_url)
  end
end

def get_mercari_image_urls(doc)
  image_urls = []
  doc.xpath('//img[@class="owl-lazy"]/@data-src').each do |src|
    image_urls << src
  end
  image_urls
end

def download_image(image_url)
  File.open('tmp/tmp.jpg', 'wb') do |file|
    open(image_url) do |img|
      file.puts img.read
    end
  end
  resize_to_850
end

def resize_to_850
  image = MiniMagick::Image.open('tmp/tmp.jpg')
  image.resize '850x850'
  image.format 'jpg'
  image.write 'tmp/output.jpg'
end

item_url = "https://item.mercari.com/jp/m62006909909/?_s=U2FsdGVkX1_IdRU8RQq0HWNkoCWRzLYt1jUnrtVk24Bqb5z5jXS9-e-x6yCRu1pdnbUCAMXmkSi-_c66xs6GSreOo4Azj29kfrGdJDfvo2nLZEKpyE5ElGFRjeWhO4DL"
get_image_urls(item_url)
