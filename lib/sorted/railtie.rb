require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    initializer "sorted.configure" do |app|
      ActiveSupport.on_load :active_record do
        require 'sorted/orms/active_record'
        include Sorted::Orms::ActiveRecord
      end
      ActiveSupport.on_load :action_view do
        require 'sorted/view_helpers/action_view'
        include Sorted::ViewHelpers::ActionView
      end
    end
  end
end
