module Tufts
  module Catalog


      def instantiate_controller_and_action_names
          @current_action = action_name
          @current_controller = controller_name
      end
  end
end