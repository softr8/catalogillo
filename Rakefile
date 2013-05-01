#!/usr/bin/env rake

begin
  ENV['BUNDLE_GEMFILE'] ||= File.dirname(__FILE__) + '/gemfiles/rails3'
  ENV['RAILS_VERSION'] ||= 'rails3'
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
  require 'rspec/core/rake_task'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Catalogillo'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


GEMFILES = %w(rails3 rails4)

namespace :test do
  desc "Installs all dependencies"
  task :setup do
    GEMFILES.each do |gemfile|
      puts "Installing gems for testing with #{gemfile} ..."
      sh "env BUNDLE_GEMFILE=#{File.dirname(__FILE__) + '/gemfiles/' + gemfile} bundle install"
    end
  end

  task :verify_gemfile do
    if Dir.glob(File.join('gemfiles', '*.lock')).empty?
      Rake::Task["test:setup"].invoke
    end
  end

  GEMFILES.each do |gemfile|
    desc "Run all tests against #{gemfile}"
    task gemfile.downcase => :verify_gemfile do
      sh "env RAILS_VERSION=#{gemfile} BUNDLE_GEMFILE=#{File.dirname(__FILE__) + '/gemfiles/' + gemfile} bundle exec rake spec"
    end
  end

  task :all => GEMFILES.map {|gemfile| "test:#{gemfile}"}
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)

desc 'Run all against every specified rails version'
task :test => 'test:all'

task :default => :test
