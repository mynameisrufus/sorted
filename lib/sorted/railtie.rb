require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    initializer "sorted.configure" do |app|
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.send :include, Sorted::Orms::ActiveRecord
      end
      ActiveSupport.on_load :action_view do
        ::ActionView::Base.send :include, Sorted::ViewHelpers::ActionView
      end
    end
  end
end
