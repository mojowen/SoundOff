class FormController < ActionController::Base
  layout 'application.html.haml'
  def start
  	@config = {
  		# :targets => [
  		# 	{ :twitter_id => 'blumenauermedia'}
  		# ],
  		# :message => 'fuck you'

  	}
  	@suggestions = [
  		'Maybe you should stop that thing that makes me upset, congress',
  		'This is where suggested tweet would go',
  		'I really can\'t think of another - it\'s prett late',
  		'Ok I thought of one more '
  	]
  end
end
