class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :hashtag
      t.text :description
      t.string :background

      t.date :end
      t.integer :goal
      t.boolean :email_required, :default => false
      t.text :suggested, :default => '[]'
      
      t.integer :partner_id

      t.timestamps
    end
    add_index :campaigns, :partner_id
  end
end
