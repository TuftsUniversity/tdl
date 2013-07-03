# -*- encoding : utf-8 -*-
class ContactController < FeedbackController
  before_filter :instantiate_controller_and_action_names

  def instantiate_controller_and_action_names
    @current_action = "contact"
    @current_controller = controller_name
  end
end
