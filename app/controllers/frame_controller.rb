class FrameController < ActionController::Base
  layout 'frame.html'
  def form
  	@config = {
  		# :targets => [
  		# 	{ :twitter_id => 'blumenauermedia'}
  		# ],
  		# :message => 'fuck you'
      :campaign => params[:campaign],
      :targets => (params[:targets] || '' ).split(',').map{ |t| { :twitter_id => t } },
      :form => true,
      :email => params[:email],
      :zip => params[:zip]
  	}
    @body_class = 'form'
    @body_class += ' dark' if params[:style] == 'dark'
    @body_class += ' light' if params[:style] == 'light'
  	@suggestions = [
  		'Maybe you should stop that thing that makes me upset, congress',
  		'This is where suggested tweet would go',
  		'I really can\'t think of another - it\'s prett late',
  		'Ok I thought of one more '
  	]
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
