class CreateSoundoffs < ActiveRecord::Migration
  def change
    create_table :soundoffs do |t|
      t.string :zip
      t.string :email
      t.string :message
      t.string :targets

      t.string :hashtag
      t.integer :campaign_id

      t.boolean :headcount, :default => false
      t.boolean :partner, :default => false

      t.string :tweet_id
      t.string :twitter_screen_name
      t.string :tweet_data, :default => '{}'


      t.timestamps
    end
    add_index :soundoffs, :campaign_id
    add_index :soundoffs, :message
  end
end
