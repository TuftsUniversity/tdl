class AboutController < ApplicationController
  before_filter :instantiate_controller_and_action_names

  def instantiate_controller_and_action_names
    @current_action = "about"
    @current_controller = controller_name
  end

  def index
  end

end
