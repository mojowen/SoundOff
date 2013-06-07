class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :hashtag
      t.text :description
      t.string :background

      t.date :end
      t.integer :goal

      t.string :email_option, :default => 'optional'
      t.string :status, :default => 'pending'
      t.string :short_url
      t.string :target, :default => 'house'

      t.text :suggested, :default => '[]'

      t.integer :partner_id

      t.timestamps
    end
    add_index :campaigns, :partner_id
    add_index :campaigns, :short_url, :unique => true
  end
end
