class HomeController < ActionController::Base
  layout 'application.html'
  
  def home
    @config = { :home => true }
    @body_class = 'home'
  end
end
