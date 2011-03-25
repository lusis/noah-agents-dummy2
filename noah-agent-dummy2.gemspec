# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "noah-agent-dummy2/version"

Gem::Specification.new do |s|
  s.name        = "noah-agent-dummy2"
  s.version     = Noah::Agent::Dummy2::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John E. Vincent"]
  s.email       = ["lusis.org+rubygems.org@gmail.com"]
  s.homepage    = "https://github.com/lusis/Noah"
  s.summary     = %q{Provides dummy2 support for Noah Watcher}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "noah-agent-dummy2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
