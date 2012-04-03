# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fraggle/block/version"

Gem::Specification.new do |s|
  s.name        = "fraggle-block"
  s.version     = Fraggle::Block::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dylan Egan", "Blake Mizerany"]
  s.email       = ["dylanegan@gmail.com", "blake.mizerany@gmail.com"]
  s.homepage    = "https://github.com/dylanegan/fraggle-block"
  s.summary     = %q{A synchronous Ruby client for Doozer.}
  s.description = %q{A synchronous Ruby client for Doozer.}

  s.rubyforge_project = "fraggle-block"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "beefcake", "~>0.3"
  s.add_dependency "protobuf", "~>1.1.3"

  s.add_development_dependency "turn"
end
