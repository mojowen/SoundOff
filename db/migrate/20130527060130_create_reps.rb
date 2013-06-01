class CreateReps < ActiveRecord::Migration
  def change
    create_table :reps do |t|
        t.integer :id

    	t.string :bioguide_id
    	t.string :chamber
    	t.string :district
    	
    	t.string :state
    	t.string :state_name
    	
    	t.string :title
    	t.string :first_name
    	t.string :last_name
    	t.string :party
    	
    	t.string :phone
    	t.string :website
    	t.string :contact_form

    	t.string :twitter_screen_name
    	t.string :twitter_id
    	t.string :twitter_profile_image

    	t.text :data, :default => '{}'

      	t.timestamps
    end
  end
end
