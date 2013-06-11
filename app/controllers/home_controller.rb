class HomeController < ApplicationController
  layout 'home.html'

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
      :random_reps => Rep.all( :order => 'RANDOM()', :limit => 10 ).map{ |r| r.data = nil; r },
      :raw_campaigns => Campaign.all.map(&:to_obj),
   	}
    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url] || params[:twitter_screen_name]
  end

  def all_names
    redirect_to home_path unless soundoffs = current_user.admin

    soundoffs = Soundoff.find_all_by_headcount( true )
    soundoffs = soundoffs.map do |soundoff|
      [
        soundoff.email,
        soundoff.zip,
        soundoff.targets,
        soundoff.hashtag,
        soundoff.tweet_id,
        soundoff.twitter_screen_name,
        soundoff.message
      ].join("\t")
    end
    soundoffs.unshift(
      [
        "email",
        "zip",
        "targets",
        "hashtag",
        "tweet_id",
        "twitter_name",
        "message"
      ].join("\t")
    )
    result =  soundoffs.join("\n")

  render :text => result
  end

end
