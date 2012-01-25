# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sorted/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sorted"
  s.version     = Sorted::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rufus Post"]
  s.email       = ["rufuspost@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/sorted"
  s.summary     = "sort data with a database"
  s.description = "lets you sort large data sets using view helpers and a scope"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "sorted"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rails", ">= 3.1.2"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "sqlite3", ">= 1.3.5"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
