require 'sorted/parser'

module Sorted
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end
