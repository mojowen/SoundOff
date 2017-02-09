class FrameController < ActionController::Base
  layout 'frame.html'

  def save
    @soundoff = Soundoff.new( params[:soundoff] )

    if @soundoff.save
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end

  end

  def form
    @campaign = Campaign.find_by_id( params[:campaign] )

  	@config = {
      :name => (@campaign.name rescue nil),
      :campaign => (@campaign.hashtag rescue nil),
      :id => (@campaign.id rescue nil),
      :short_url => (@campaign.short_url rescue ''),
      :target => (@campaign.target.downcase rescue nil),
      :email_required => (@campaign.email_option == 'required' rescue false),
      :no_email => ( ! @campaign.collect_email rescue false),
      :form => true,
      :targets => (params[:targets] || '' ).split(',').map{ |t| { :twitter_id => t } },
      :email => params[:email],
      :zip => params[:zip],
      :message => params[:message],
      :page_url => params[:page_url],
      :post_message_to => params[:post_message_to],
      :skip_when_matched => false
  	}
    @body_class = "form"
    @body_class += " #{@campaign.hashtag}" if @campaign
    @body_class += ' dark' if params[:style] == 'dark'
    @body_class += ' light' if params[:style] == 'light'

    if params[:skip_when_matched] && @campaign
      @config[:skip_when_matched] = @campaign.suggested.to_a.flatten.select{ |l| l.length > 1 }.first || true
    end
  end

  def widget
    @body_class = 'form'
    @body_class += ' dark' if params[:style] == 'dark'

    campaign = Campaign.find( params[:campaign] )
    tweets = Status.hashtag( campaign.hashtag, 0, 20 )

    tweets = campaign.sample_tweets if tweets.length < 1 && params[:demo]
    params[:hashtag] ||= campaign.hashtag
    case campaign.target
        when 'house'
          @button = "Your House Rep"
        when 'senate'
          @button = 'Your Senators'
        else
          @button = 'Congress'
    end

    @config = {
      :campaign => params[:campaign],
      :raw_tweets => tweets
    }
    render 'frame/widget.html', :layout => false
  end
  def direct
    campaign = Campaign.find_by_short_url params[:short_url]
    reps = JSON::parse( RestClient.get "https://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&zip=#{params[:zip]}" )
    reps = reps['results']

    # Filtering down the reps
    case campaign.target
        when 'house'
          reps.select!{ |r| r['chamber'] == 'house' }
          limit  = 1
        when 'senate'
          reps.select!{ |r| r['chamber'] == 'senate' }
          limit  = 2
        else
          limit = 3
    end

    if reps.length < limit
      redirect_to :action => 'form', :email => params[:email], :message => ( params[:message] || campaign.suggested.to_a.flatten.select{ |l| l.length > 1 }.first ), :skip_when_matched => true, :campaign => campaign.id
    elsif reps.length > limit
      redirect_to :action => 'form', :zip => params[:zip], :email => params[:email], :message => ( params[:message] || campaign.suggested.to_a.flatten.select{ |l| l.length > 1 }.first ), :skip_when_matched => true, :campaign => campaign.id
    else
      targets = reps.map{ |s| "@#{Rep.find_by_bioguide_id( s['bioguide_id'] ).twitter_screen_name}" }.join(' ')
      message = ["\u200B"+targets, ( params[:message] || campaign.suggested.to_a.flatten.select{ |l| l.length > 1 }.first ),'#'+campaign.hashtag].join(' ')
      headcount = campaign.partner.nil?

      Soundoff.new( { :message => message, :targets =>  targets, :hashtag => campaign.hashtag, :zip => params[:zip], :campaign_id => campaign.id, :email => params[:email], :partner => true, :headcount => headcount } ).save

      redirect_to '/redirect#'+URI.escape(message).gsub(/\#/,'%23').gsub(/\&/,'%26')
    end

  end
  def demo
  end
end
