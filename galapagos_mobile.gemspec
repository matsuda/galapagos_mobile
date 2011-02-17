# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "galapagos_mobile/version"

Gem::Specification.new do |s|
  s.name        = "galapagos_mobile"
  s.version     = GalapagosMobile::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kosuke Matsuda"]
  s.email       = ["hi@matsuda.me"]
  s.homepage    = "http://github.com/matsuda/galapagos_mobile"
  s.summary     = %q{A Ruby on Rails plugin to patch jpmobile}
  s.description = %q{A Ruby on Rails plugin to patch jpmobile}

  s.rubyforge_project = "galapagos_mobile"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.date = %q{2011-02-17}
  s.add_dependency("jpmobile", ">= 0.1.4")
end
