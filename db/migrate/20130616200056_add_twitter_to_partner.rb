class AddTwitterToPartner < ActiveRecord::Migration
  def change
  	add_column :partners, :twitter_screen_name, :string
  	add_column :partners, :twitter_data, :text, :default => '{}'
  end
end
