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
      :no_email => (@campaign.collect_email rescue true),
      :form => true,
      :targets => (params[:targets] || '' ).split(',').map{ |t| { :twitter_id => t } },
      :email => params[:email],
      :zip => params[:zip],
      :message => params[:message]
  	}
    @body_class = 'form'
    @body_class += ' dark' if params[:style] == 'dark'
    @body_class += ' light' if params[:style] == 'light'

    @suggestions = (@campaign.suggestions rescue [])
  end

  def widget
    @body_class = 'form'
    @body_class += ' dark' if params[:style] == 'dark'
    @config = {
      :campaign => params[:campaign]
    }
    render 'frame/widget.html', :layout => false
  end
  def demo
  end
end
