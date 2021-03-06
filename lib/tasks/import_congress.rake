require 'csv'
require 'open-uri'

states = {
    'AL'=>'ALABAMA',
    'AK'=>'ALASKA',
    'AS'=>'AMERICAN SAMOA',
    'AZ'=>'ARIZONA',
    'AR'=>'ARKANSAS',
    'CA'=>'CALIFORNIA',
    'CO'=>'COLORADO',
    'CT'=>'CONNECTICUT',
    'DE'=>'DELAWARE',
    'DC'=>'DISTRICT OF COLUMBIA',
    'FM'=>'FEDERATED STATES OF MICRONESIA',
    'FL'=>'FLORIDA',
    'GA'=>'GEORGIA',
    'GU'=>'GUAM GU',
    'HI'=>'HAWAII',
    'ID'=>'IDAHO',
    'IL'=>'ILLINOIS',
    'IN'=>'INDIANA',
    'IA'=>'IOWA',
    'KS'=>'KANSAS',
    'KY'=>'KENTUCKY',
    'LA'=>'LOUISIANA',
    'ME'=>'MAINE',
    'MH'=>'MARSHALL ISLANDS',
    'MD'=>'MARYLAND',
    'MA'=>'MASSACHUSETTS',
    'MI'=>'MICHIGAN',
    'MN'=>'MINNESOTA',
    'MS'=>'MISSISSIPPI',
    'MO'=>'MISSOURI',
    'MT'=>'MONTANA',
    'NE'=>'NEBRASKA',
    'NV'=>'NEVADA',
    'NH'=>'NEW HAMPSHIRE',
    'NJ'=>'NEW JERSEY',
    'NM'=>'NEW MEXICO',
    'NY'=>'NEW YORK',
    'NC'=>'NORTH CAROLINA',
    'ND'=>'NORTH DAKOTA',
    'MP'=>'NORTHERN MARIANA ISLANDS',
    'OH'=>'OHIO',
    'OK'=>'OKLAHOMA',
    'OR'=>'OREGON',
    'PW'=>'PALAU',
    'PA'=>'PENNSYLVANIA',
    'PR'=>'PUERTO RICO',
    'RI'=>'RHODE ISLAND',
    'SC'=>'SOUTH CAROLINA',
    'SD'=>'SOUTH DAKOTA',
    'TN'=>'TENNESSEE',
    'TX'=>'TEXAS',
    'UT'=>'UTAH',
    'VT'=>'VERMONT',
    'VI'=>'VIRGIN ISLANDS',
    'VA'=>'VIRGINIA',
    'WA'=>'WASHINGTON',
    'WV'=>'WEST VIRGINIA',
    'WI'=>'WISCONSIN',
    'WY'=>'WYOMING',
    'AE'=>'ARMED FORCES AFRICA \ CANADA \ EUROPE \ MIDDLE EAST',
    'AA'=>'ARMED FORCES AMERICA (EXCEPT CANADA)',
    'AP'=>'ARMED FORCES PACIFIC'
}

def check_user maybe_rep, twitter_user
    puts maybe_rep.to_json
    puts "#{maybe_rep.first_name} #{maybe_rep.last_name} #{maybe_rep.state} #{maybe_rep.district}"
    puts "----------"
    puts "#{twitter_user.name}: #{twitter_user.description}"
    puts "http://twitter.com/#{twitter_user.screen_name}"

    puts "\n\n"
    puts "Add this Twitter Account to Rep #{maybe_rep.first_name} #{maybe_rep.last_name} (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
        maybe_rep.twitter_screen_name = twitter_user.screen_name
        maybe_rep.add_twitter()
        maybe_rep.save()
        puts "\n\n\n\n"
    else
        puts "Skipping"
        puts "\n\n\n\n"
    end
end


task :import_twitter_handles => :environment do |t,args|

    handle = args.first || 'cspan'
    list = args.last || 'members-of-congress'

    puts "Importing #{handle}/#{list}"
    cspan_list = TWITTER_CLIENT.list_members(handle, list).to_a
    sad_list = Rep.find_all_by_twitter_id(nil)

    cspan_list.each do |twitter_user|
        unless Rep.find_by_twitter_id "#{twitter_user.id}"
            maybe_rep = sad_list.select{ |c| c.last_name.downcase == twitter_user.name.split(/\s/).last.downcase }
            maybe_rep += sad_list.select{ |c| (twitter_user.name+twitter_user.screen_name).downcase.index(c.last_name.downcase) }

            maybe_rep.uniq.each{ |rep| check_user(rep, twitter_user) }
        end
    end


end

task :import_congress => :environment  do

    full_list = 'http://unitedstates.sunlightfoundation.com/legislators' \
                '/legislators.csv'

    data = CSV.parse( open(full_list) )

    labels = data.shift()

    translate = {
        "firstname" => "first_name",
        "lastname" => "last_name",
    }

    data.each do |row|
        raw_rep = {}

        labels.each_with_index do |column, index|
            raw_rep[ translate[column] || column ] = row[index]
        end
        raw_rep['state_name'] = states[ raw_rep['state'] ]
        raw_rep['chamber'] = raw_rep['title'] == 'Rep' ? 'house' : 'senate'
        raw_rep['district'] = raw_rep['title'] == 'Rep' ? raw_rep['district'] : nil

        if Rep.find_by_bioguide_id( raw_rep['bioguide_id'] ).nil? && raw_rep['in_office'] == '1'
            rep = Rep.add_custom_rep( raw_rep )
            if rep.save()
                puts "Imported #{rep.first_name} #{rep.last_name}"
            end
        end
    end

end
