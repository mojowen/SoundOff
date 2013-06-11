class Soundoff < ActiveRecord::Base
	attr_accessible :zip, :email, :message, :targets, :hashtag, :campaign_id, :headcount, :partner, :tweet_id, :tweet_screen_name, :tweet_data

	serialize :tweet_data, JSON
end
