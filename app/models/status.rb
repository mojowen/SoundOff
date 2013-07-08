# encoding: utf-8
class Status < ActiveRecord::Base
	attr_accessible :tweet_id, :screen_name, :user_id, :tweet_date, :data, :message, :hashtags, :mentions

	serialize :data, JSON

	belongs_to :soundoff

	def self.create_from_tweet raw_tweet
		raw_tweet = JSON::parse(raw_tweet) if raw_tweet.class == String

		hashtags = raw_tweet['entities']['hashtags'].map{ |f| f['text'].downcase }
		mentions = raw_tweet['entities']['user_mentions'].map{ |f| f['id_str'] }

		zero_width_space = "\xE2\x80\x8B"

		tweet = self.new(
			:tweet_id => raw_tweet['id_str'],
			:screen_name => raw_tweet['user']['screen_name'],
			:user_id => raw_tweet['user']['id_str'],
			:tweet_date => raw_tweet['created_at'],
			:message => raw_tweet['text'].gsub(/#{zero_width_space}/,''),
			:hashtags => hashtags.join(','),
			:mentions => mentions.join(','),
			:data => raw_tweet
		)

		# Matching campaigns
		match_campaign = Campaign.count( :conditions => ['lower(hashtag) IN(?)', hashtags ] ) > 0

		# Matching Reps
		match_reps = Rep.count( :conditions => ['twitter_id IN(?)', mentions ] ) > 0

		# Match reply
		reply = self.find_by_tweet_id( raw_tweet["in_reply_to_status_id_str"] )

		unless reply.nil?
			tweet.reply_id = reply.id
			match_reply = true
		else
			match_reply = false
		end

	 	tweet.save if match_reply || match_campaign || match_reps
	end

	before_create :match_soundoff

	def match_soundoff
		if new_record?
			match = Soundoff.where([' message LIKE ? AND tweet_id IS NULL',message]).first
			unless match.nil?
				match.twitter_screen_name = screen_name
				match.tweet_id = tweet_id
				match.save

				self.soundoff_id = match.id
			end
		end
	end
	def self.hashtag hashtags, limit=50,  offset=0
		hashtags = hashtags.split(',') if hashtags.class != Array
		hashtags = hashtags.map{ |v| "%#{v.downcase}%" }.join('|')

		return all( :limit => limit,
			:order => 'created_at DESC',
			:conditions => ['lower(hashtags) SIMILAR TO ?',hashtags]
		)
	end
	def self.mention mentions,limit=50, offset=0
		mentions = mentions.split(',') if mentions.class != Array
		mentions = mentions.map{ |v| "%#{v}%" }.join('|')

		return all( :limit => limit,
			:order => 'created_at DESC',
			:conditions => ['LOWER(mentions) SIMILAR TO ?',mentions]
		)
	end


end
