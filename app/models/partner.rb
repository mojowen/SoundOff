class Partner < ActiveRecord::Base
  	attr_accessible :name, :website, :tax_id, :logo, :partner_type,
  		:contact_email, :contact_phone, :contact_name, :contact_password
	attr_accessor :contact_email, :contact_phone, :contact_name, :contact_password

  	has_many :users, :dependent => :delete_all
  	has_many :campaigns

	before_save :set_up_individual_partner

	def set_up_individual_partner
		if self.partner_type == 'individual'
			self.name = self.contact_name
		end
		self.errors.add :tax_id, 'Nonprofits require tax ids' if self.partner_type == 'nonprofit' && self.tax_id.nil?
	end

	after_save :update_user

	def update_user
		if contact_name || contact_phone || contact_password || contact_email
			user = self.users.first || self.users.new

			user[:email] = contact_email if ! contact_email.nil? && ! contact_email.empty?
			user[:name] = contact_name if ! contact_name.nil? && ! contact_name.empty?
			user[:phone] = contact_phone if ! contact_phone.nil? && ! contact_phone.empty?
			user.password = contact_password if ! contact_password.nil? && ! contact_password.empty?
			user.password_confirmation = contact_password if ! contact_password.nil? && ! contact_password.empty?

			user.save
		end
	end

end
