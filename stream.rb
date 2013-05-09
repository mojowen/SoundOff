require "twitterstream"

ts = TwitterStream.new('sduncombe','stinging1')

ts.sample do |status|
  user = status['user']
  puts "#{user['screen_name']}: #{status['text']}"
end