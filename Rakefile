require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'sorted'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RuboCop::RakeTask.new

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sorted #{Sorted::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :benchmark do
  require 'benchmark'

  uri = 'email_desc!name_desc'
  sql = 'email ASC, phone ASC, name DESC'

  uri_set = Sorted::SQLQuery.parse(uri)
  sql_set = Sorted::SQLQuery.parse(sql)

  n = 50_000
  Benchmark.bm do |x|
    # Query
    x.report(:uri_parse) { for _ in 1..n; Sorted::URIQuery.parse(uri); end }
    x.report(:sql_parse) { for _ in 1..n; Sorted::SQLQuery.parse(sql); end }

    # Set
    x.report(:direction_intersect) { for _ in 1..n; sql_set.direction_intersect(uri_set); end }
  end
end

task default: ['rubocop', 'spec']
