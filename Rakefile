require 'bundler'
Bundler::GemHelper.install_tasks

HOME  = ENV["HOME"]
PBDIR = HOME+"/Code/heroku/doozer/src/pkg/proto"

namespace :proto do
  task :update do
    ENV["BEEFCAKE_NAMESPACE"] = "Fraggle::Block"
    sh(
      "protoc",
      "--beefcake_out", "lib/fraggle/block",
      "-I",  PBDIR,
      PBDIR+"/msg.proto"
    )
  end
end

require 'rake/testtask'

namespace :test do
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
end
