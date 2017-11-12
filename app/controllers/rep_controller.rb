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
		elsif search.length == 2
			all_reps = Rep.find_all_by_state( search.upcase  )
		else
			all_reps = Rep.lookup(twitter_list + bio_list)
		end

		render json: all_reps.map{ |r| r.data = nil;  r[:score] = r.score; r }
	end
end
