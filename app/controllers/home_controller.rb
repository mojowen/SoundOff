class HomeController < ActionController::Base
  layout 'application.html'
  
  def home
  	
  	if params[:twitter_screen_name]
  		rep = Rep.find_by_twitter_screen_name( params[:twitter_screen_name] )
  		rep.data = nil
      rep[:short_url] = rep_path( rep.twitter_screen_name )
  	end

    @config = { 
    	:home => true, 
    	:single => params[:short_url] || rep || nil,
      :random_reps => Rep.all( :order => 'RANDOM()', :limit => 10 ).map{ |r| r.data = nil; r }
   	}
    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url] || params[:twitter_screen_name]
  end

end
