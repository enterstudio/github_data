# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "github_cli"
  s.version = "0.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Piotr Murach"]
  s.date = "2013-10-06"
  s.description = "CLI-based access to GitHub API v3"
  s.email = [""]
  s.executables = ["gcli"]
  s.files = ["bin/gcli"]
  s.homepage = "http://github.com/peter-murach/github_cli"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "github_cli is a set of tools that provide full command line access to GitHub API v3"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<github_api>, ["~> 0.10"])
      s.add_runtime_dependency(%q<tty>, ["~> 0.0.10"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<communist>, [">= 0"])
      s.add_development_dependency(%q<ronn>, [">= 0"])
    else
      s.add_dependency(%q<github_api>, ["~> 0.10"])
      s.add_dependency(%q<tty>, ["~> 0.0.10"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<communist>, [">= 0"])
      s.add_dependency(%q<ronn>, [">= 0"])
    end
  else
    s.add_dependency(%q<github_api>, ["~> 0.10"])
    s.add_dependency(%q<tty>, ["~> 0.0.10"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<communist>, [">= 0"])
    s.add_dependency(%q<ronn>, [">= 0"])
  end
end
