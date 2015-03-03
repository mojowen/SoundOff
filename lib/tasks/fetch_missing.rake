task :fetch_missing do
	require 'rest_client'
	require 'nokogiri'
	require 'json'

	twitters = Dir.glob('lib/reps/no_twitter/*')
	reps = {}


	twitters.each do |rep_file|

		pool = ["Rep. Alan Grayson (AlanGrayson) on Twitter", "Alcee Hastings (alceehastings) on Twitter", "Rep Allyson Schwartz (GoAllySchwartz) on Twitter", "Bill Cassidy (BillCassidy) on Twitter", "Billy Long (auctnr1) on Twitter", "Brett Guthrie (RepGuthrie) on Twitter", "Charlie Dent (DentforCongress) on Twitter", "Rep. Chris Smith (RepChrisSmith) on Twitter", "Dana Rohrabacher (DanaRohrabacher) on Twitter", "Danny K Davis (DannyKDavis) on Twitter", "D Wasserman Schultz (DWStweets) on Twitter", "Duncan Hunter (DuncanHunter) on Twitter", "Pastor For Arizona (PastorForAZ) on Twitter", "Frank D. Lucas (FrankDLucas) on Twitter", "Rep. Jeff Miller (RepJeffMiller) on Twitter", "Joe Garcia (JoeGarcia) on Twitter", "John Mica (micaforcongress) on Twitter", "Rep. Leonard Lance (RepLanceNJ7) on Twitter", "Mike Capuano (mikecapuano) on Twitter", "House Transportation (HouseTransInf) on Twitter", "Rep. Peter Welch (PeterWelch) on Twitter", "Rob Andrews (RepAndrews) on Twitter", "Rob Woodall (votewoodall) on Twitter", "Rodney Frelinghuysen (RodneyforNJ) on Twitter", "Rush Holt (RushHolt) on Twitter", "SmallBizGOP (SmallBizGOP) on Twitter", "Rep. Susan Davis (RepSusanDavis) on Twitter", "Thomas Massie (RepThomasMassie) on Twitter", "Tom Petri (tompetri68) on Twitter", "Rep. Trey Radel (treyradel) on Twitter", "Al Franken (alfranken) on Twitter", "Amy Klobuchar (amyklobuchar) on Twitter", "Chris Murphy (ChrisMurphyCT) on Twitter", "David Vitter (DavidVitter) on Twitter", "Senator Jim Risch (SenatorRisch) on Twitter", "Jon Tester (jontester) on Twitter", "Kelly Ayotte (KellyAyotte) on Twitter", "Kirsten Gillibrand (SenGillibrand) on Twitter", "Max Baucus (MaxBaucus) on Twitter"].map(&:downcase)
		ids = ["AlanGrayson", "alceehastings", "GoAllySchwartz", "BillCassidy", "auctnr1", "RepGuthrie", "DentforCongress", "RepChrisSmith", "DanaRohrabacher", "DannyKDavis", "DWStweets", "DuncanHunter", "PastorForAZ", "FrankDLucas", "RepJeffMiller", "JoeGarcia", "micaforcongress", "RepLanceNJ7", "mikecapuano", "HouseTransInf", "PeterWelch", "RepAndrews", "votewoodall", "RodneyforNJ", "RushHolt", "SmallBizGOP", "RepSusanDavis", "RepThomasMassie", "tompetri68", "treyradel", "alfranken", "amyklobuchar", "ChrisMurphyCT", "DavidVitter", "SenatorRisch", "jontester", "KellyAyotte", "SenGillibrand", "MaxBaucus"]

		rep = JSON::parse( File.read( rep_file  ) )

		spot = pool.find{ |v| v.index(rep['last_name'].downcase ) }
		spot = pool.index(spot)

		unless spot.nil?
			twitter_id = ids[spot]
			rep['twitter_id'] = twitter_id
			reps[twitter_id] = { :data => rep, :file => rep_file.gsub('no_twitter','maybe_twitter') }
		end

		# url = "https://www.google.com/search?q="+( [ rep['title'],rep['first_name'],rep['last_name']].join(' ')+" site:twitter.com twitter").gsub(/\s/,'+')
		# page = RestClient.get url
		# html = Nokogiri::HTML( page )

		# twitter_id = html.xpath('//h3').first

		# if twitter_id

		# 	find_id = twitter_id.text.match(/\(.*.*\)/)

		# 	if find_id

		# 		rep['twitter_id'] = find_id.to_s.gsub(/\(|\)/,'')

		# 		reps[twitter_id] = { :data => rep, :file => rep_file.gsub('no_twitter','maybe_twitter') }
		# 	else
		# 		puts "not match on #{twitter_id}"

		# 	end

		# else
		# 	puts "failed on #{rep['title']} #{rep['first_name']} #{rep['last_name']} "
		# end

	end

	smooshed = reps.map{|k,v| k }.join(',')

	puts smooshed
	url = "https://api.twitter.com/1/users/lookup.json"
	ids = JSON::parse( RestClient.post url, { screen_name: smooshed, include_entities: true } )

	reps.each do |twitter_id, rep_package|

		t_scrape = ids.find{ |t| t['screen_name'] == twitter_id }

		unless t_scrape.nil?

			puts "Matching #{twitter_id} with number #{t_scrape['id']}"

			rep_package[:data]['twitter_id_number'] = t_scrape['id']
			rep_package[:data]['twitter_scrape'] = t_scrape

			File.open( rep_package[:file] ,'w+'){ |f| f.write( rep_package[:data].to_json ) }

			record = [
				t_scrape['screen_name'],
				t_scrape['description']
			].join("\t")+"\n"

			File.open( 'lib/reps/done_ids.txt','a'){ |f| f.write( record ) }
		end

	end

end
