class HomeController < ApplicationController
  layout 'home.html'

  def home

  	if params[:twitter_screen_name]
  		rep = Rep.where( ['LOWER(twitter_screen_name) = ? ',params[:twitter_screen_name].downcase]).first
      redirect_to home_path if rep.nil?

  		rep.data = nil unless rep.data
      rep[:short_url] = rep_path( rep.twitter_screen_name )
      rep[:tweets] = []

      @title = '@ '+rep.name
      @og_title = @title+' | #SoundOff @ Congress'
      @og_description = "#SoundOff @ #{rep.name} from #{rep.state_name} and see what others are saying. #SoundOff is an advocacy tool created and maintained by HeadCount.org."
      @og_image = 'https://api.twitter.com/1/users/profile_image?screen_name='+rep.twitter_screen_name
      raw_tweets = Status.mention rep.twitter_id
  	end
    campaign = Campaign.find_by_short_url( params[:short_url] ) if params[:short_url]
    if campaign

      @title = campaign.name+' #'+ campaign.hashtag
      @og_title = @title+' | #SoundOff @ Congress'
      @og_description = campaign.description
      @og_image = (campaign.partner.logo rescue nil)
    end

    if params[:email] || params[:zip] || params[:targets] || params[:message]
      open_soundoff = {
        :email => params[:email],
        :zip => params[:zip],
        :targets => params[:targets],
        :message => params[:message],
        :no_click => true
      }
    else
      open_soundoff = false
    end


    @config = {
    	:home => true,
    	:single => params[:short_url] || rep || nil,
      :raw_reps => Rep.mentioned.reject{ |r| r == rep }.map{ |r| r.data = nil; r[:tweets] = []; r },
      :raw_campaigns => Campaign.active.map(&:to_obj),
      :open_soundoff => open_soundoff,
      :raw_tweets => (raw_tweets || [])
    }
    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url] || params[:twitter_screen_name]
  end

  def all_names
    only_logged_in

    if current_user.admin
      @soundoffs = Soundoff.find_all_by_headcount( true )
    else
      @soundoffs = current_user.partner.all_signups
    end

    render :template => 'home/soundoff_export', :layout => false
  end

  def all_tweets
    only_logged_in

    if current_user.admin
      @statuses = Status.where('reply_to IS NULL').reverse
    else
      @statuses = current_user.partner.all_tweets
    end

    render :template => 'home/status_export', :layout => false
  end
  def all_responses
    only_logged_in

    if current_user.admin
      @statuses = Status.where('reply_to IS NOT NULL').reverse
    else
      @statuses = current_user.partner.all_responses
    end

    render :template => 'home/status_export', :layout => false
  end

  def statuses
    tweets = Status.hashtag( params[:hashtags] )
    tweets = Status.mention( params[:mentions] )
    render :json => tweets.sort_by(&:created_at).reverse
  end

  def sitemap


    @urls = [
        # A place to put urls
        # { :priority => '0.4', :url => ENV['BASE_URL']+'/about', :updated => '2012-10-05'},
        # { :priority => '0.4', :url => ENV['BASE_URL']+'/guides', :updated => newwest_user > newwest_feedback ? newwest_user.to_date : newwest_feedback.to_date  }
        { :priority => '0.4', :url => ENV['BASE_URL'], :updated => Soundoff.all( :order => 'created_at DESC',:limit => 1).first.created_at  }
      ]

    @urls += Campaign.active.map do |campaign|
      { :priority => '1.0', :url => campaign.url , :updated => campaign.updated.to_date  }
    end

    @urls += Rep.active.map{ |rep| { :priority => '0.6', :url => rep.url, :updated => rep.updated.to_date } }

    if params[:format] == 'json'
      render :json => @urls.count
    else
      render :template => 'home/sitemap', :layout => false
    end
  end

end
