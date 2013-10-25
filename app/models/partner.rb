class Partner < ActiveRecord::Base
	attr_accessible :name, :website, :tax_id, :logo, :partner_type,
		:contact_email, :contact_phone, :contact_name, :contact_password, :twitter_screen_name, :twitter_data, :privacy_policy, :mailing_address, :hear_about_soundoff
	attr_accessor :contact_email, :contact_phone, :contact_name, :contact_password

	serialize :twitter, JSON
  	has_many :users, :dependent => :delete_all
  	has_many :campaigns, :order => 'created_at DESC'

	before_save :set_up_individual_partner, :twitter_data, :partner_url

	def set_up_individual_partner
		if self.partner_type == 'individual'
			self.name = self.contact_name
		end
		self.errors.add :tax_id, 'Nonprofits require tax ids' if self.partner_type == 'nonprofit' && self.tax_id.nil?
	end
	def twitter_data
		self.twitter_screen_name = twitter_screen_name.gsub('@','')
		begin
			tw = Twitter.user(self.twitter_screen_name)
			self.twitter_data = tw.to_json
			self.logo = tw.profile_image_url
		rescue
			return errors[:base] << 'Bad Twitter'
			self.logo = '/assets/sq_icon.jpg'
		end
	end
	def partner_url
		return false if self.website.nil? || self.website.empty?
		self.website = 'http://'+self.website unless self.website.index('http')
	end

	before_save :update_user

	def update_user
		if contact_name || contact_phone || contact_password || contact_email

			user = self.users.first || self.users.new

			user[:email] = contact_email if ! contact_email.nil? && ! contact_email.empty?
			user[:name] = contact_name if ! contact_name.nil? && ! contact_name.empty?
			user[:phone] = contact_phone if ! contact_phone.nil? && ! contact_phone.empty?
			user.password = contact_password if ! contact_password.nil? && ! contact_password.empty?
			user.password_confirmation = contact_password if ! contact_password.nil? && ! contact_password.empty?

			if user.valid?
				user.save
			else
				errors[:email] << user.errors.messages[:email].first if user.errors.messages[:email]
				errors[:password] << user.errors.messages[:password].first if user.errors.messages[:password]
				return false
			end
		end
	end
	def contact_user
		self.users.first || self.users.new
	end
	def show_contact_email
		contact_user.email
	end
	def show_contact_phone
		contact_user.phone
	end
	def show_contact_name
		contact_user.name
	end
	def count_tweets
		hashtags = campaigns.all.map(&:hashtag).map{ |v| "%#{v.downcase}%" }.join('|')
      	Status.count( :conditions => ['reply_to IS NULL AND lower(hashtags) SIMILAR TO ?',hashtags])
	end
	def all_tweets
		hashtags = campaigns.all.map(&:hashtag).map{ |v| "%#{v.downcase}%" }.join('|')
      	Status.where(['reply_to IS NULL AND lower(hashtags) SIMILAR TO ?',hashtags]).reverse
	end
	def count_responses
		hashtags = campaigns.all.map(&:hashtag).map{ |v| "%#{v.downcase}%" }.join('|')
      	Status.count( :conditions => ['reply_to IS NOT NULL AND lower(hashtags) SIMILAR TO ?',hashtags])
	end
	def all_responses
		hashtags = campaigns.all.map(&:hashtag).map{ |v| "%#{v.downcase}%" }.join('|')
      	Status.where(['reply_to IS NOT NULL AND lower(hashtags) SIMILAR TO ?',hashtags]).reverse
	end
	def count_signups
		Soundoff.count( :conditions => ['partner IS TRUE AND campaign_id = ?',self.id] )
	end
	def all_signups
		campaigns = self.campaigns.all.map(&:id)
		@soundoffs = Soundoff.where(['partner IS TRUE AND campaign_id IN(?) AND length(email) > 0',campaigns]).reverse
    end
	def count_signups
		campaigns = self.campaigns.all.map(&:id)
      	@soundoffs = Soundoff.count( :conditions => ['partner IS TRUE AND campaign_id IN(?)',campaigns])
    end
end
