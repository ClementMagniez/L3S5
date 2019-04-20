require "rake/testtask"

task :default => [:run]


task :run do
	ruby "lib/main.rb"
end

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end
