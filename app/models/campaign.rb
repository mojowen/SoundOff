class Campaign < ActiveRecord::Base
	attr_accessible :description, :hashtag, :name, :partner, :background,
		:email_option, :end, :goal, :suggested, :target

	serialize :suggested, JSON

	belongs_to :partner

	# has_many :tweets
	# has_many :emails

	before_save :fix_suggested, :fix_short_url, :notify_pending, :notify_active
	def fix_suggested
		if suggested.class == Hash
			self.suggested = self.suggested.map{ |k,v| v }.reject{ |l| l.empty? }
		end
	end
	def fix_short_url
		self.short_url = SecureRandom.urlsafe_base64( 3, false) if short_url.nil?
	end
	def notify_pending
		CampaignMail.new_campaign( self ).deliver if ! self.partner.nil? && self.new_record?
	end
	def notify_active
		CampaignMail.campaign_approved( self ).deliver if !self.partner.nil? && self.status == 'approved'
	end

	# Normal methods
	def url
		(ENV['BASE_DOMAIN'] || '') + '/' + self.short_url
	end
	def collect_email
		if partner.nil?
			return true
		else
			return partner.partner_type == 'nonprofit'
		end
	end
	def score
		Soundoff.count( :conditions => { :campaign_id => id } )
	end
	def to_obj
		return {
			:name => name,
			:score => score,
			:description => description,
			:id => id,
			:hashtag => '#'+hashtag,
			:partner => (partner.name rescue nil),
			:logo => ( (partner.logo.empty? ? '/assets/sq_icon.jpg' : partner.logo) rescue '/assets/sq_icon.jpg' ),
			:website => (partner.website rescue nil),
			:tweets => [],
			:created_at => created_at,
			:short_url => short_url
		}
	end
	def self.active
    	return all( :conditions => { :status => 'approved'} )
	end
	def updated
		if last_soundoff = Soundoff.all( :limit => 1, :conditions => { :campaign_id => id}, :order => 'created_at DESC' ).first
			return last_soundoff.created_at
		else
			return updated_at
		end
	end

end