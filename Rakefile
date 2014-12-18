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

namespace :spec do
  desc 'Run Tests against all ORMs'
  task :all do
    %w(active_record_40 mongoid_30).each do |gemfile|
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
    end
  end
end

task :benchmark do
  require 'benchmark'

  sort   = 'email_desc!name_desc'
  order  = 'email ASC, phone ASC, name DESC'

  n = 50_000
  Benchmark.bm do |x|
    x.report(:lazy) { for i in 1..n; Sorted::Parser.new(sort, order); end }
    x.report(:to_hash) { for i in 1..n; Sorted::Parser.new(sort, order).to_hash; end }
    x.report(:to_sql) { for i in 1..n; Sorted::Parser.new(sort, order).to_sql; end }
    x.report(:to_a) { for i in 1..n; Sorted::Parser.new(sort, order).to_a; end }
    x.report(:toggle) { for i in 1..n; Sorted::Parser.new(sort, order).toggle; end }
  end
end

task default: ['rubocop', 'spec:all']
