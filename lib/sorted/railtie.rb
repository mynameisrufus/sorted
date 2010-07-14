require 'sorted'

module Sorted
  class Railtie < Rails::Railtie
    initializer "sorted.active_record" do |app|
      require 'sorted/active_record'
      Sorted::ActiveRecord.enable!
    end
    
    initializer "sorted.action_view" do |app|
      require 'sorted/action_view'
      ActionView::Base.send(:include, Sorted::ActionView)
    end
  end
end
