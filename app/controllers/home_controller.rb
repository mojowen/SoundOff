class HomeController < ActionController::Base
  layout 'application.html'
  
  def home
  	
  	if params[:twitter_screen_name]
  		rep = Rep.find_by_twitter_screen_name( params[:twitter_screen_name] )
  		rep.data = nil
      rep[:short_url] = rep_path( rep.twitter_screen_name )

      @title = '@ '+rep.name
      @og_title = @title+' | #SoundOff @ Congress'
      @og_description = "#SoundOff @ #{rep.name} from #{rep.state_name} and see what others are saying. #SoundOff is an advocacy tool created and maintained by HeadCount.org."
      @og_image = 'https://api.twitter.com/1/users/profile_image?screen_name='+rep.twitter_screen_name
      
  	end

    # Will want to do something here with campaigns

    @config = { 
    	:home => true, 
    	:single => params[:short_url] || rep || nil,
      :random_reps => Rep.all( :order => 'RANDOM()', :limit => 10 ).map{ |r| r.data = nil; r }
   	}
    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url] || params[:twitter_screen_name]
  end

end
