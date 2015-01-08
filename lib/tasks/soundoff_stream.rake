
task :soundoff_stream => :environment  do

	TweetStream.configure do |config|
	  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
	  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
	  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
	  config.oauth_token_secret = ENV['TWITTER_OATH_SECRET']
	  config.auth_method        = :oauth
	end


	stream = TweetStream::Client.new

	stream.on_error do |message|
		puts "Error - #{message}"
	end

	stream.on_reconnect do |timeout, retries|
		puts "Timeout #{timeout} with #{retries} retries"
	end

	stream.track('#soundoff','#SoundOff') do |status|
	  Status.create_from_tweet(status)
	end

	all_reps = Rep.active.map(&:twitter_id).map(&:to_i)

	stream.follow( all_reps ) do |status|
		Status.create_from_tweet(status)
	end


end