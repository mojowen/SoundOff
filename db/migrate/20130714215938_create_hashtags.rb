class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
    	t.string :keyword

		t.timestamps
    end
    create_table 'hashtags_statuses' do |t|
    	t.references :status, :null => false
    	t.references :hashtag, :null => false
    end
    create_table 'reps_statuses' do |t|
    	t.references :status, :null => false
    	t.references :rep, :null => false
    end
    add_index :reps_statuses, [:rep_id, :status_id]
    add_index :hashtags_statuses, [:hashtag_id, :status_id]

    add_index :reps, :twitter_id, :uniq => true
    add_index :hashtags, :keyword, :uniq => true
  end
end
