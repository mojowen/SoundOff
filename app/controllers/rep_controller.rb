class RepController < ApplicationController
	def index
		all_reps = Rep.all
		render :json => all_reps.map{ |r| r.data = nil; r[:score] = r.score; }
	end
	def search
		search = params[:q] || ''
		twitter_list = (params[:sns] || '' ).downcase.split(',')
		bio_list = (params[:bio] || '' ).downcase.split(',')

		if search.length > 3
			all_reps = Rep.search( search )
		elsif  search.length == 2
			all_reps = Rep.find_all_by_state( search.upcase  )
		elsif twitter_list.length > 0 && search.length < 2
			all_reps = Rep.all( :conditions => ['LOWER(twitter_screen_name) IN(?)',twitter_list] )
		elsif bio_list.length > 0 && search.length < 2
			all_reps = Rep.all( :conditions => ['LOWER(bioguide_id) IN(?)',bio_list] )
			bio_list.reject{ |id| all_reps.map(&:bioguide_id).index(id) }.each{ |id| Rep.retrieve_new_rep(id) }
		else
			all_reps = {}
		end

		render :json => all_reps.map{ |r| r.data = nil;  r[:score] = r.score; r }
	end
end