require 'flickraw'

API_KEY = ENV['FLICKRAW_API_KEY']
SHARED_SECRET = ENV['FLICKRAW_SHARED_SECRET']


FlickRaw.api_key = API_KEY
FlickRaw.shared_secret = SHARED_SECRET

flickr = FlickRaw::Flickr.new

# 認証完了 ユーザ名-> yasuo.yusuke token-> 72157707071274571-f8dd75b34b7ee97d secret-> 67b58a161ece19a7
ACCESS_TOKEN = ENV['FLICKR_ACCESS_TOKEN']
ACCESS_SECRET = ENV['FLICKR_ACCESS_SECRET']
PHOTO_PATH='tmp/output.jpg'

flickr.access_token = ACCESS_TOKEN
flickr.access_secret = ACCESS_SECRET

flickr.upload_photo PHOTO_PATH, :title => 'Title', :description => 'This is the description'
