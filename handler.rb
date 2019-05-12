require 'json'
require 'open-uri'
require 'mini_magick'
require 'net/http'

def download_image
  File.open('tmp/tmp.jpg', 'wb') do |file|
    open('https://img.fril.jp/img/214847566/l/611236820.jpg?1553352512') do |img|
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

download_image
