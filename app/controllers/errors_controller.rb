class ErrorsController < ApplicationController
  before_filter :set_body_class

  def set_body_class
    @body_class = 'error'
  end

  def five_hundred
    render status: 500, template: 'errors/500'
  end

  def four_oh_four
    render status: 404, template: 'errors/404'
  end
end
