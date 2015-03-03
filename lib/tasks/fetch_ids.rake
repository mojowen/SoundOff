task :fetch_ids do
	require 'rest_client'
	require 'json'

	twitters = Dir.glob('lib/reps/has_twitter/*')

	# (twitters.length / 100.to_f).ceil.times do |i|

		chunk = twitters.map do |f|
			{ :data => JSON::parse( File.read(f) ), :file => f.to_s}
		end

		chunk = chunk.select{ |f| f[:data]['twitter_id_number'].nil? }

		reps = {}

		chunk.each do |rep_file|
			reps[ rep_file[:data]['twitter_id'] ] = rep_file
		end

		smooshed = reps.map{|k,v| k }.join(',')
		url = "https://api.twitter.com/1/users/lookup.json"
		ids = JSON::parse( RestClient.post url, { screen_name: smooshed, include_entities: true } )

		reps.each do |twitter_id, rep_package|

			t_scrape = ids.find{ |t| t['screen_name'].downcase == twitter_id.downcase }

			unless t_scrape.nil?

				puts "Matching #{twitter_id} with number #{t_scrape['id']}"

				rep_package[:data]['twitter_id_number'] = t_scrape['id']
				rep_package[:data]['twitter_scrape'] = t_scrape

				File.open( rep_package[:file] ,'w+'){ |f| f.write( rep_package[:data].to_json ) }
			end
		end

	# end

end
