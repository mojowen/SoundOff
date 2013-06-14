class Soundoff < ActiveRecord::Base
	attr_accessible :zip, :email, :message, :targets, :hashtag, :campaign_id, :headcount, :partner, :tweet_id, :twitter_screen_name

	serialize :tweet_data, JSON
	has_one :status
end
