class Rep < ActiveRecord::Base
	attr_accessible :bioguide_id, :chamber, :district, :state, :state_name,
		:title, :first_name, :last_name,
		:party, :phone, :website, :contact_form,
		:twitter_screen_name, :twitter_id, :twitter_profile_image, :data,
		:short_url

	serialize :data, JSON

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
		if last_soundoff = Soundoff.all( :limit => 1, :conditions => ['"targets" LIKE(?)','%'+twitter_screen_name+'%'], :order => 'created_at DESC' ).first
			return last_soundoff.created_at
		else
			return updated_at
		end
  	end
  	def self.active
  		all( :conditions => ['char_length("twitter_screen_name") > 0'] )
  	end
end
