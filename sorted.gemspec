# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sorted/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sorted"
  s.version     = Sorted::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rufus Post", "Daniel Leavitt"]
  s.email       = ["rufuspost@gmail.com", "daniel.leavitt@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/sorted"
  s.summary     = %q{Data sorting library}
  s.description = %q{Allows you to sort large datasets over many pages, without losing state.}
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "sorted"

  s.add_development_dependency "rake", ">= 0"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "activesupport", ">= 3.0.0"
  s.add_development_dependency "actionpack", ">= 3.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
