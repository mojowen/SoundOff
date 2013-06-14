class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
    	t.datetime :tweet_date
      t.string :screen_name
      t.string :user_id
      t.string :hashtags
      t.string :mentions

    	t.text :message

    	t.integer :soundoff_id
      t.integer :reply_to

    	t.text :data, :default => '{}'

      	t.timestamps
    end
    add_index :tweets, :tweet_id
    add_index :tweets, :reply_to
    add_index :tweets, :soundoff_id
  end
end
