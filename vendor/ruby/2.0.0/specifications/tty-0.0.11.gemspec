# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tty"
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Piotr Murach"]
  s.date = "2013-08-19"
  s.description = "Toolbox for developing CLI clients"
  s.email = [""]
  s.homepage = "http://github.com/peter-murach/tty"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Toolbox for developing CLI clients"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<benchmark_suite>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7.1"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.6.7"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<benchmark_suite>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
      s.add_dependency(%q<coveralls>, ["~> 0.6.7"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<benchmark_suite>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
    s.add_dependency(%q<coveralls>, ["~> 0.6.7"])
  end
end
