class Rep < ActiveRecord::Base
	attr_accessible :bioguide_id, :chamber, :district, :state, :state_name,
		:title, :first_name, :last_name,
		:party, :phone, :website, :contact_form,
		:twitter_screen_name, :twitter_id, :twitter_profile_image, :data,
		:short_url

	serialize :data, JSON
  has_and_belongs_to_many :statuses

	validates_uniqueness_of :bioguide_id

	def self.search search
		all(
			:conditions => [
					'LOWER(first_name) || \' \' || LOWER(last_name) LIKE :search OR LOWER(state_name) LIKE :search OR LOWER(twitter_screen_name) LIKE :search',
					{ :search => "%#{search.downcase}%" }
				]
			)
  	end

  	def name
  		return [title,first_name,last_name].join(' ')
  	end
  	def url
		(ENV['BASE_DOMAIN'] || '') + '/rep/' + self.twitter_screen_name
  	end
  	def updated
  		if last_soundoff = Status.joins(:found_reps).where(['"reps"."twitter_id" = ?',twitter_id]).order('created_at DESC' ).limit(1).first
  			return last_soundoff.created_at
  		else
  			return updated_at
  		end
  	end
    def score
      return Status.joins(:found_reps).where(['"reps"."twitter_id" = ?',twitter_id]).count
    end

  	def self.active
  		all( :conditions => ['char_length("twitter_screen_name") > 0'] )
  	end
  	def self.mentioned
  		return Rep.joins(:statuses).limit(50).group('reps.id').order('count("statuses"."id") DESC')
  	end
    def self.add_custom_rep args

      twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
        config.access_token_secret = ENV['TWITTER_OATH_SECRET']
      end

      t = twitter_client.user( args[:twitter_screen_name] )
      args[:twitter_id] = t.id.to_s
      args[:twitter_profile_image] = t.profile_image_url.to_str
      args[:data] = t
      new( args )
    end

    def self.retrieve_new_rep(bioguide_id)
      Thread.new do
        bioguide_id = bioguide_id.upcase
        sunlight_data = JSON.parse RestClient.get "https://congress.api.sunlightfoundation.com/legislators?bioguide_id=#{bioguide_id}&all_legislators=true&apikey=8fb5671bbea849e0b8f34d622a93b05a"

        new_rep_raw = sunlight_data['results'][0]
        new_rep = {}

        attr_accessible[:default].reject{ |k| k.length < 1 }.each do |k|
          new_rep[k.to_sym] = new_rep_raw[k] if new_rep_raw[k]
        end

        new_rep[:twitter_screen_name] = new_rep[:twitter_id]

        add_custom_rep( new_rep ).save()
      end
    end
end
