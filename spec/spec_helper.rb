$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

begin
    require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'sorted'
require 'sorted/orms/mongoid'
require 'sorted/orms/active_record'
require 'sorted/view_helpers/action_view'
require 'rspec'
