require 'flickraw'

API_KEY = ENV['FLICKRAW_API_KEY']
SHARED_SECRET = ENV['FLICKRAW_SHARED_SECRET']


FlickRaw.api_key = API_KEY
FlickRaw.shared_secret = SHARED_SECRET

flickr = FlickRaw::Flickr.new
token = flickr.get_request_token

auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')
puts "このURLをブラウザで開いて認証プロセスを完了させてください : #{auth_url}"
verify = gets.strip

begin
  flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
  login = flickr.test.login
  puts "認証完了 ユーザ名-> #{login.username} token-> #{flickr.access_token} secret-> #{flickr.access_secret}"
rescue => e
  puts "認証失敗: #{e.msg}"
end
