class Campaign < ActiveRecord::Base
	attr_accessible :description, :hashtag, :name, :partner, :background,
		:email_option, :end, :goal, :suggested, :target

	serialize :suggested, JSON

	belongs_to :partner

	# has_many :tweets
	# has_many :emails

	before_save :fix_suggested
	def fix_suggested
		if suggested.class == Hash
			self.suggested = self.suggested.map{ |k,v| v }.reject{ |l| l.empty? }
		end
	end
end
