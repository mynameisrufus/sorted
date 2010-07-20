require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sorted"
    gem.summary = %Q{sort a table}
    gem.description = %Q{lets you sort tables (or somthing else) using a view helper and a custom scope}
    gem.email = "rufuspost@gmail.com"
    gem.homepage = "http://github.com/mynameisrufus/sorted"
    gem.authors = ["Rufus Post"]
    gem.add_dependency "activerecord", ">= 3.0.0"
    gem.add_development_dependency "rspec", ">= 2.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
