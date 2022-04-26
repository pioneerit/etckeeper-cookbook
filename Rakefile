require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'cookstyle'

RuboCop::RakeTask.new(:rubocop)

RSpec::Core::RakeTask.new(:rspec)

RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

task default: [:rubocop, :cookstyle, :rspec]
