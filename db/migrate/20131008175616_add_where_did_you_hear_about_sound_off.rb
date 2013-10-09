class AddWhereDidYouHearAboutSoundOff < ActiveRecord::Migration
  def change
  	add_column :partners, :hear_about_soundoff, :string
  end

end
