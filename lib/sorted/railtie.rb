require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    initializer "sorted.active_record" do |app|
      if defined? ::ActiveRecord
        require 'sorted/orms/active_record'
        Sorted::Orms::ActiveRecord.enable!
      end
    end
    
    initializer "sorted.action_view" do |app|
      require 'sorted/view_helpers/action_view'
      ::ActionView::Base.send(:include, Sorted::ViewHelpers::ActionView)
    end
  end
end
