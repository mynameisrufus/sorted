require 'sorted/sorter'
require 'sorted/toggler'

module Sorted
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end
