class AddToPartner < ActiveRecord::Migration

  def change
  	add_column :partners, :mailing_address, :string
  	add_column :partners, :privacy_policy, :string
  end

end
