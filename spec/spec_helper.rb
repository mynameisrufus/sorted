$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sorted/active_record'
require 'sorted/action_view'
require 'rspec'
require 'rspec/autorun'
