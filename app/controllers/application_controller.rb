class ApplicationController < ActionController::Base
  protect_from_forgery

  def only_logged_in
  	redirect_to home_path if !!! current_user
  end

  def after_sign_in_path_for(resource)
    campaigns_path
  end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  private
  def render_not_found(exception)
      @msg = exception.to_s.split(' ').map{|w| w[0].upcase+w.slice(1,w.length)}.join(' ')
      @body_class = 'error'
     render :template => "/errors/404", :status => 404, :layout => 'application.html.haml'
  end

  def render_error(exception)
    @msg = exception.to_s.split(' ').map{|w| w[0].upcase+w.slice(1,w.length)}.join(' ')
    @backtrace = exception.backtrace.join("\n")
    @body_class = 'error'
    render :template => "/errors/500", :status => 500, :layout => 'application.html.haml'
  end
end
