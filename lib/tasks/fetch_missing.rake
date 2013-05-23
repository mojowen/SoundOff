task :fetch_missing do
	require 'rest_client'
	require 'nokogiri'
	require 'json'
	
	twitters = Dir.glob('lib/reps/no_twitter/*')
	reps = {}

	twitters.each do |rep_file|


		rep = JSON::parse( File.read( rep_file  ) )


		url = "https://www.google.com/search?q="+( [ rep['title'],rep['first_name'],rep['last_name']].join(' ')+" site:twitter.com twitter").gsub(/\s/,'+')
		page = RestClient.get url
		html = Nokogiri::HTML( page )

		twitter_id = html.xpath('//h3').first

		if twitter_id

			find_id = twitter_id.text.match(/\(.*.*\)/)

			if find_id

				rep['twitter_id'] = find_id.to_s.gsub(/\(|\)/,'')

				reps[twitter_id] = { :data => rep, :file => rep_file.gsub('no_twitter','maybe_twitter') }
			else
				puts "not match on #{twitter_id}"

			end
			
		else
			puts "failed on #{rep['title']} #{rep['first_name']} #{rep['last_name']} "
		end

	end

	smooshed = reps.map{|k,v| k }.join(',')

	puts smooshed
	url = "https://api.twitter.com/1/users/lookup.json"
	ids = JSON::parse( RestClient.post url, { screen_name: smooshed, include_entities: true } )

	# reps.each do |twitter_id, rep_package|
		
	# 	t_scrape = ids.find{ |t| t['screen_name'] == twitter_id }
		
	# 	unless t_scrape.nil?
			
	# 		puts "Matching #{twitter_id} with number #{t_scrape['id']}"

	# 		rep_package[:data]['twitter_id_number'] = t_scrape['id']
	# 		rep_package[:data]['twitter_scrape'] = t_scrape

	# 		File.open( rep_package[:file] ,'w+'){ |f| f.write( rep_package[:data].to_json ) }
			
	# 		record = [
	# 			t_scrape['screen_name'],
	# 			t_scrape['description']
	# 		].join("\t")

	# 		File.open( 'lib/reps/done_ids.txt','a'){ |f| f.write( record ) }
	# 	end

	# end
	
end
