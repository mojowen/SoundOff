task :fetch_ids do
	require 'rest_client'
	require 'json'
	
	twitters = Dir.glob('lib/reps/has_twitter/*')

	(twitters.length / 100.to_f).ceil.times do |i|

		chunk = twitters.slice(i*100, 100)

		reps = {}

		chunk.each do |rep_file|
			tmp_rep = JSON::parse( File.read( rep_file  ) )

			reps[ tmp_rep['twitter_id'] ] = { :data => tmp_rep, :file => rep_file.to_s }
		end

		smooshed = reps.map{|k,v| k }.join(',')
		url = "https://api.twitter.com/1/users/lookup.json"
		ids = JSON::parse( RestClient.post url, { screen_name: smooshed, include_entities: true } )

		reps.each do |twitter_id, rep_package|
			
			t_scrape = ids.find{ |t| t['screen_name'] == twitter_id }
			
			unless t_scrape.nil?
				
				puts "Matching #{twitter_id} with number #{t_scrape['id']}"

				rep_package[:data]['twitter_id_number'] = t_scrape['id']
				rep_package[:data]['twitter_scrape'] = t_scrape

				File.open( rep_package[:file] ,'w+'){ |f| f.write( rep_package[:data].to_json ) }
			end
		end

	end
	
end