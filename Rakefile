require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :rspec

desc 'Runs rspec tests'
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = Dir.glob('spec/*_spec.rb')
end
