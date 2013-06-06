class ApplicationController < ActionController::Base
  protect_from_forgery

  def only_logged_in
  	redirect_to home_path if !!! current_user
  end

end
