class HomeController < ActionController::Base
  layout 'application.html'
  
  def home
    @config = { :home => true }
  end
end
