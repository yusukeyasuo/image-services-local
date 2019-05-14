require 'json'
require 'open-uri'
require 'mini_magick'
require 'net/http'
require 'nokogiri'
require 'aws-sdk-s3'

def get_image_urls(url)
  puts "[start] get_image_urls"
  charset = 'utf-8'

  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  image_urls = if url.match(/\Ahttps:\/\/item.mercari.com/)
                 get_mercari_image_urls(doc)
               elsif url.match(/\Ahttps:\/\/item.fril.jp/)
                 get_fril_image_urls(doc)
               else
                 []
               end

  image_urls.each do |image_url|
    puts '[start] download_image'
    puts image_url
    download_image(image_url.to_s)
  end
end

def get_mercari_image_urls(doc)
  image_urls = []
  doc.xpath('//img[@class="owl-lazy"]/@data-src').each do |src|
    image_urls << src
  end
  image_urls
end

def get_fril_image_urls(doc)
  image_urls = []
  doc.xpath('//img[@class="sp-image"]/@src').each do |src|
    image_urls << src
  end
  image_urls
end

def download_image(image_url)
  match = image_url.match(/([a-zA-Z0-9]+\.jpg)/)
  file_name = match[1]
  File.open("tmp/#{file_name}", 'wb') do |file|
    open(image_url) do |img|
      file.puts img.read
    end
  end
  resize_to_850(file_name)
end

def resize_to_850(file_name)
  image = MiniMagick::Image.open("tmp/#{file_name}")
  image.resize '850x850'
  image.format 'jpg'
  image.write "tmp/resized_#{file_name}"
end

#item_url = "https://item.mercari.com/jp/m62006909909/?_s=U2FsdGVkX1_IdRU8RQq0HWNkoCWRzLYt1jUnrtVk24Bqb5z5jXS9-e-x6yCRu1pdnbUCAMXmkSi-_c66xs6GSreOo4Azj29kfrGdJDfvo2nLZEKpyE5ElGFRjeWhO4DL"
item_url = "https://item.fril.jp/750029bbf335d74fbc730a285ff36468"
get_image_urls(item_url)
