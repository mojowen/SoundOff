# encoding: utf-8
class Status < ActiveRecord::Base
	attr_accessible :tweet_id, :screen_name, :user_id, :tweet_date, :data, :message, :hashtags, :mentions

	serialize :data, JSON

	belongs_to :soundoff
	has_and_belongs_to_many :found_reps, class_name: 'Rep'
	has_and_belongs_to_many :found_hashtags, class_name: 'Hashtag'

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
		campaigns = Campaign.all( :conditions => ['lower(hashtag) IN(?)', hashtags ] )
		match_campaign = campaigns.length > 0

		# Matching Reps
		reps = Rep.all( :conditions => ['twitter_id IN(?)', mentions ] )
		match_reps = reps.length > 0

		# Match reply
		reply = self.find_by_tweet_id( raw_tweet["in_reply_to_status_id_str"] )

		unless reply.nil?
			tweet.reply_id = reply.id
			match_reply = true
		else
			match_reply = false
		end

		if match_reply || match_campaign || match_reps
			tweet.save
			tweet.index_to_reps_and_hashtags reps, campaigns
		end
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
	def index_to_reps_and_hashtags reps=nil,campaigns=nil
		campaigns = Campaign.all( :conditions => ['lower(hashtag) IN(?)', hashtags.downcase.split(',') ] ) if campaigns.nil?
		reps = Rep.all( :conditions => ['twitter_id IN(?)', mentions.split(',') ] ) if reps.nil?

		reps.each{ |r| r.statuses << self }

		campaigns.each do |r|
			hashtag = Hashtag.find_by_keyword(r.hashtag.downcase)
			if hashtag.nil?
				hashtag = Hashtag.new( :keyword => r.hashtag.downcase)
				hashtag.save
			end
			hashtag.statuses << self
		end
	end

	def self.hashtag hashtags, offset=0, limit=30
		hashtags = hashtags.downcase.split(',') if hashtags.class != Array
		hashtags.map!{ |v| v.downcase }

		return Status.limit(limit).offset(offset).order('created_at DESC').joins(:found_hashtags).where(['lower("hashtags"."keyword") IN(?)',hashtags])
	end
	def self.mention mentions, offset=0, limit=30
		mentions = mentions.split(',') if mentions.class != Array
		return Status.limit(limit).offset(offset).order('created_at DESC').joins(:found_reps).where(['"reps"."twitter_id" IN(?)',mentions])
	end
	def to_json
		{
			:tweet_id => tweet_id,
			:screen_name => screen_name,
			:profile_image_url => data['user']['profile_image_url'],
			:message => message,
			:hashtags => hashtags,
			:mentions => mentions,
			:created_at => data['created_at']
		}
	end

end
