class HomeController < ActionController::Base
  layout 'application.html'
  
  def home
    @config = { :home => true, :single => params[:short_url] }
    @body_class = 'home'
    @body_class += ' fixed' if params[:short_url]
  end

end
