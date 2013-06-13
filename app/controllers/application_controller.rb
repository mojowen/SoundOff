class ApplicationController < ActionController::Base
  protect_from_forgery

  def only_logged_in
  	redirect_to home_path if !!! current_user
  end

  def after_sign_in_path_for(resource)
    campaigns_path
  end

end
