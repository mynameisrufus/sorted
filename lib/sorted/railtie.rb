require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    initializer 'sorted.configure' do |_app|
      if defined? ::ActiveRecord
        ActiveSupport.on_load :active_record do
          require 'sorted/orms/active_record'
          include Sorted::Orms::ActiveRecord
        end
      end

      if defined? ::Mongoid
        require 'sorted/orms/mongoid'
        ::Mongoid::Document.send :include, Sorted::Orms::Mongoid
      end

      ActiveSupport.on_load :action_view do
        require 'sorted/view_helpers/action_view'
        include Sorted::ViewHelpers::ActionView
      end
    end
  end
end
