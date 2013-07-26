class HomeController < ApplicationController
  layout 'home.html'

  def home

  	if params[:twitter_screen_name]
  		rep = Rep.where( ['LOWER(twitter_screen_name) = ? ',params[:twitter_screen_name].downcase]).first
      redirect_to home_path if rep.nil?

  		rep.data = nil unless rep.data
      rep[:short_url] = rep_path( rep.twitter_screen_name )
      rep[:tweets] = []
      rep[:score] = rep.score

      @title = '@ '+rep.name
      @og_title = @title+' | #SoundOff @ Congress'
      @og_description = "#SoundOff @ #{rep.name} from #{rep.state_name} and see what others are saying. #SoundOff is an advocacy tool created and maintained by HeadCount.org."
      @og_image = 'https://api.twitter.com/1/users/profile_image?screen_name='+rep.twitter_screen_name
      raw_tweets = Status.mention( rep.twitter_id ).map(&:to_json)
  	end
    campaign = Campaign.find_by_short_url( params[:short_url] ) if params[:short_url]
    if campaign

      @title = campaign.name+' #'+ campaign.hashtag
      @og_title = @title+' | #SoundOff @ Congress'
      @og_description = campaign.description
      @og_image = (campaign.partner.logo rescue nil)
      raw_tweets = Status.hashtag( campaign.hashtag ).map(&:to_json)
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

    if params[:short_url] == 'home'
      params[:short_url] = nil
      is_home = true
    else
      is_home = false
    end

    @config = {
      :home => true,
    	:single => params[:short_url] || rep || nil,
      :raw_reps => Rep.mentioned.reject{ |r| r == rep }.map{ |r| r.data = nil; r[:tweets] = []; r[:score] = r.score; r },
      :raw_campaigns => Campaign.active.map(&:to_obj),
      :open_soundoff => open_soundoff,
      :raw_tweets => (raw_tweets || []),
      :skip_landing => is_home
    }

    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url] || params[:twitter_screen_name] || is_home
  end

  def all_names
    only_logged_in
    require 'csv'

    if current_user.admin
      soundoffs = Soundoff.where(['headcount = ? AND length(email) > 0 ',true])
    else
      soundoffs = current_user.partner.all_signups
    end

    result = CSV.generate do |csv|
      csv << [ "email", "message", "zip", "sent_date",'tweet link', "screen name"]
      soundoffs.each do |soundoff|
        csv << [soundoff.email,soundoff.message,soundoff.zip,soundoff.created_at,("https://twitter.com/"+soundoff.twitter_screen_name+"/status/"+soundoff.tweet_id rescue ''), soundoff.twitter_screen_name]
      end
    end

    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=all_emails.csv", :filename => "all_emails.csv"

  end

  def all_tweets
    only_logged_in
    require 'csv'

    if current_user.admin
      statuses = Status.where('reply_to IS NULL').reverse
    else
      statuses = current_user.partner.all_tweets
    end

    result = CSV.generate do |csv|
      csv << [ "screen name", "message", "tweet date",'tweet link', "hashtags","mentions"]
      statuses.each do |soundoff|
        csv << [soundoff.screen_name,soundoff.message,soundoff.tweet_date,("https://twitter.com/"+soundoff.screen_name+"/status/"+soundoff.tweet_id rescue ''),soundoff.data['entities']['hashtags'].map{|r| r['text'] }.join(', '), soundoff.data['entities']['user_mentions'].map{|r| r['screen_name'] }.join(', ')]
      end
    end

    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=all_tweets.csv", :filename => "all_tweets.csv"
  end
  def all_responses
    only_logged_in
    require 'csv'

    if current_user.admin
      statuses = Status.where('reply_to IS NOT NULL').reverse
    else
      statuses = current_user.partner.all_responses
    end

    result = CSV.generate do |csv|
      csv << [ "screen name", "message", "tweet date",'tweet link', "hashtags","mentions"]
      statuses.each do |soundoff|
        csv << [soundoff.screen_name,soundoff.message,soundoff.tweet_date,("https://twitter.com/"+soundoff.screen_name+"/status/"+soundoff.tweet_id rescue ''),soundoff.data['entities']['hashtags'].map{|r| r['text'] }.join(', '), soundoff.data['entities']['user_mentions'].map{|r| r['screen_name'] }.join(', ')]
      end
    end

    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=all_responses.csv", :filename => "all_responses.csv"
  end

  def statuses
    tweets = Status.hashtag( params[:hashtags], params[:offset] ) if params[:hashtags]
    tweets = Status.mention( params[:mentions], params[:offset] ) if params[:mentions]
    render :json => tweets.sort_by(&:created_at).map(&:to_json).reverse
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
