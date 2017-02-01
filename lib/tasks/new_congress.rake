require 'json'
require 'rest-client'

task :new_congress => :environment  do
  url = "https://congress.api.sunlightfoundation.com/legislators?" \
        "apikey=8fb5671bbea849e0b8f34d622a93b05a&per_page=all&in_office=true"

  elected = JSON.parse(RestClient.get(url)).fetch('results')

  missing = elected.reject { |rep| Rep.Rep.find_by_bioguide_id(rep["bioguide_id"]) }
  missing.each { |rep| Rep.retrieve_new_rep_sync(rep["bioguide_id"]) }

  puts "==================== MISSING TWITTER ===================="
  puts elected.map { |rep| Rep.find_by_bioguide_id(rep["bioguide_id"]) }
              .reject { |r| r.try(:twitter_screen_name) }
              .map { |r|
                  ["#{r.first_name} #{r.last_name}",
                   r.bioguide_id,
                   "#{r.district ? "District " + r.district : "Senator"} #{r.state}",
                   "#{r.website}"].join("\t")
              }
              .join("\n")
end
