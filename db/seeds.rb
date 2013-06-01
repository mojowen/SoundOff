# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

reps = Dir.glob './lib/reps/has_twitter/*'

reps.each do |rep|
	rep_raw = JSON::parse( File.read( rep) )
	unprotected = [ :bioguide_id, :chamber, :district, :state, :state_name, :title, :first_name, :last_name, :party, :phone, :website, :contact_form, :twitter_screen_name, :twitter_id, :twitter_profile_image, :data ]
	rep_clean = {}

	unprotected.each do |k|
		rep_clean[k] = rep_raw[ k.to_s ]
	end

	rep_clean[:twitter_screen_name] = rep_raw['twitter_id']
	rep_clean[:twitter_id] = rep_raw['twitter_scrape']['id_str']
	rep_clean[:twitter_profile_image] = rep_raw['twitter_scrape']['profile_image_url']
	rep_clean[:data] = rep_raw


	Rep.new( rep_clean ).save
end