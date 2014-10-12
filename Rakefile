# encoding: utf-8

require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'foodcritic'

RuboCop::RakeTask.new(:rubocop)

RSpec::Core::RakeTask.new(:rspec)

FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['any'] }
end

task default: [:rubocop, :foodcritic, :rspec]
