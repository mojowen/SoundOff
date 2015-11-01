class Rep < ActiveRecord::Base
	attr_accessible :bioguide_id, :chamber, :district, :state, :state_name,
		:title, :first_name, :last_name,
		:party, :phone, :website, :contact_form,
		:twitter_screen_name, :twitter_id, :twitter_profile_image, :data,
		:short_url

	serialize :data, JSON
  has_and_belongs_to_many :statuses

	validates_uniqueness_of :bioguide_id

	def self.search search
		all(
			:conditions => [
					'LOWER(first_name) || \' \' || LOWER(last_name) LIKE :search OR LOWER(state_name) LIKE :search OR LOWER(twitter_screen_name) LIKE :search',
					{ :search => "%#{search.downcase}%" }
				]
			)
  	end

  	def name
  		return [title,first_name,last_name].join(' ')
  	end
  	def url
		(ENV['BASE_DOMAIN'] || '') + '/rep/' + self.twitter_screen_name
  	end
  	def updated
  		if last_soundoff = Status.joins(:found_reps).where(['"reps"."twitter_id" = ?',twitter_id]).order('created_at DESC' ).limit(1).first
  			return last_soundoff.created_at
  		else
  			return updated_at
  		end
  	end
    def score(pre_score=nil)
      if pre_score
        pre_score[self.twitter_id] || 0
      else
        Status.joins(:found_reps).where(['"reps"."twitter_id" = ?',twitter_id]).count
      end
    end
    def add_twitter
        return self unless self.twitter_screen_name

        t = TWITTER_CLIENT.user( self.twitter_screen_name )
        self.twitter_id = t.id.to_s
        self.twitter_profile_image = t.profile_image_url.to_str
        self.data = t
        return self
    end

  	def self.active
  		all( :conditions => ['char_length("twitter_screen_name") > 0'] )
  	end
    def self.mentioned
      return Rep.joins(:statuses).limit(50).group('reps.id').order('count("statuses"."id") DESC')
    end
  	def self.mentioned_to_objs(rejected=nil)
      mentioned_reps = mentioned.reject{ |r| r == rejected }
      pre_score = Hash[ Rep.joins('INNER JOIN "reps_statuses" ON "reps_statuses"."rep_id" = "reps"."id"')
                 .select('COUNT(reps_statuses.status_id), twitter_id')
                 .where(['twitter_id IN (?)', mentioned_reps.map(&:twitter_id)])
                 .group('twitter_id')
                 .to_a
                 .map{ |rep| [rep.twitter_id, rep.count.to_i] } ]
      mentioned.map do |rep|
        base_rep = rep.as_json
        base_rep[:data] = nil
        base_rep[:tweets] = []
        base_rep[:score] = rep.score(pre_score)
        base_rep
      end
  	end
    def self.add_custom_rep args

      new_rep = {}

      attr_accessible[:default].reject{ |k| k.length < 1 }.each do |k|
        new_rep[k.to_sym] = args[k] if args[k]
      end

      if new_rep[:twitter_id]
        new_rep[:twitter_screen_name] = new_rep[:twitter_id]
        new_rep[:twitter_id] = nil
      end

      new( new_rep )
    end

    def self.retrieve_new_rep bioguide_id
      Thread.new do
        bioguide_id = bioguide_id.upcase
        sunlight_data = JSON.parse RestClient.get "https://congress.api.sunlightfoundation.com/legislators?bioguide_id=#{bioguide_id}&all_legislators=true&apikey=8fb5671bbea849e0b8f34d622a93b05a"

        new_rep = add_custom_rep( sunlight_data['results'][0] )
        new_rep = add_twitter(new_rep) if new_rep.twitter_screen_name
        new_rep.save()
      end
    end
end
