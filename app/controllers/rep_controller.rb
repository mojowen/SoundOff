class RepController < ActionController::Base
	def index
		all_reps = Rep.all
		render :json => all_reps.map{ |r| r.data = nil; r }
	end
	def search
		search = params[:q] || ''
		list = (params[:sns] || '' ).downcase.split(',')

		if search.length > 3
			all_reps = Rep.search( search )
		elsif  search.length == 2
			all_reps = Rep.find_all_by_state( search.upcase  )
		elsif list.length > 0 && search.length < 2
			all_reps = Rep.all( :conditions => ['LOWER(twitter_screen_name) IN(?)',list] )
		else
			all_reps = {}
		end

		render :json => all_reps.map{ |r| r.data = nil;  r }
	end
end