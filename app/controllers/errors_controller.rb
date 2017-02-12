class ErrorsController < ApplicationController
  before_filter :set_body_class

  def set_body_class
    @body_class = 'error'
  end
end
