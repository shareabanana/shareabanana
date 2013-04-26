# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "coinbase"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Armstrong"]
  s.date = "2013-04-18"
  s.description = "[\"Wrapper for the Coinbase Oauth2 API\"]"
  s.email = [""]
  s.homepage = "https://coinbase.com/api/doc"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "[\"Wrapper for the Coinbase Oauth2 API\"]"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.12"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<multi_json>, [">= 1.3.4"])
      s.add_runtime_dependency(%q<money>, [">= 4.0.1"])
      s.add_runtime_dependency(%q<hashie>, [">= 1.2.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.12"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0.8.3"])
      s.add_dependency(%q<multi_json>, [">= 1.3.4"])
      s.add_dependency(%q<money>, [">= 4.0.1"])
      s.add_dependency(%q<hashie>, [">= 1.2.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.12"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0.8.3"])
    s.add_dependency(%q<multi_json>, [">= 1.3.4"])
    s.add_dependency(%q<money>, [">= 4.0.1"])
    s.add_dependency(%q<hashie>, [">= 1.2.0"])
  end
end
