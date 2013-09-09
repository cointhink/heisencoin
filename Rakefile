require 'bundler/setup'
require 'rake/testtask'
$LOAD_PATH << File.dirname(__FILE__)+"/lib"

Rake::TestTask.new do |t|
  t.pattern = "tests/*.rb"
end

task :default => [:test] do
end
