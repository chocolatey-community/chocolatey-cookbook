#!/usr/bin/env rake

require 'rspec/core/rake_task'

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    require 'rubocop/rake_task'
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any'],
        chef_version: '11.14.0'
      }
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

namespace :maintain do
  require 'stove/rake_task'
  Stove::RakeTask.new
end

namespace :test do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
end

desc 'Run all tests on Travis'
task travis: ['style']

# Default
task default: ['style']
