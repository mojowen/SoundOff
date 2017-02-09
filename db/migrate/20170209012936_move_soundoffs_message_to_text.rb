class MoveSoundoffsMessageToText < ActiveRecord::Migration
  def up
    change_column :soundoffs, :message, :text
  end
end
