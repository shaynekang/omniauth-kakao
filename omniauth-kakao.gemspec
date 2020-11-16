# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-kakao/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-kakao"
  s.version     = Omniauth::Kakao::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Shayne Sung-Hee Kang"]
  s.email       = ["shayne.kang@gmail.com"]
  s.homepage    = "https://github.com/shaynekang/omniauth-kakao"
  s.summary     = %q{OmniAuth strategy for Kakao}
  s.description = %q{OmniAuth strategy for Kakao(http://developers.kakao.com/)}
  s.license     = "MIT"

  s.rubyforge_project = "omniauth-kakao"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.3.1'

  s.add_development_dependency 'rspec', '~> 2.14', '>= 2.14.1'
  s.add_development_dependency 'guard-rspec', '~> 4.2', '>= 4.2.8'
  s.add_development_dependency 'fakeweb', '~> 1.3', '>= 1.3.0'
end
