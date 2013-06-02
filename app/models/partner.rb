class Partner < ActiveRecord::Base
  attr_accessible :name, :website, :tax_id, :logo, :partner_type,
  	:contact_email, :contact_phone, :contact_name,

  has_many :users
  has_many :campaigns
end
