require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "groundcrew"
    gem.summary = %Q{a simple library for running things on http://Groundcrew.us}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "joe@citizenlogistics.com"
    gem.homepage = "http://github.com/citizenlogistics/groundcrew"
    gem.authors = ["Joe Edelman"]
    gem.add_development_dependency "minitest", ">= 0"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_dependency('rest-client')
    gem.add_dependency('yajl-ruby')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
