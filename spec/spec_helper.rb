$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sorted'
require 'sorted/orms/mongoid'
require 'sorted/orms/active_record'
require 'sorted/view_helpers/action_view'
require 'rspec'
