require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    if defined? ::ActiveRecord
      initializer "sorted.active_record" do |app|
        require 'sorted/orms/active_record'
        ::ActiveRecord::Base.send(:include, Sorted::Orms::ActiveRecord)
      end
    end
    
    if defined? ::ActiveRecord
      initializer "sorted.action_view" do |app|
        require 'sorted/view_helpers/action_view'
        ::ActionView::Base.send(:include, Sorted::ViewHelpers::ActionView)
      end
    end
  end
end
