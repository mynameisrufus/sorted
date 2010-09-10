$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sorted/finders/active_record'
require 'sorted/view_helpers/action_view'
require 'rspec'
require 'rspec/autorun'
