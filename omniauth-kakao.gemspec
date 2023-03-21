$:.push File.expand_path('../lib', __FILE__)
require 'omniauth-kakao/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-kakao'
  s.version     = Omniauth::Kakao::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Shayne Sung-Hee Kang']
  s.email       = ['shayne.kang@gmail.com']
  s.homepage    = 'https://github.com/shaynekang/omniauth-kakao'
  s.summary     = %q{Omniauth strategy for Kakao}
  s.description = %q{Omniauth strategy for Kakao (https://developers.kakao.com/)}
  s.license     = 'MIT'

  s.rubyforge_project = 'omniauth-kakao'

  s.files         = Dir['lib/**/*'] + %w[README.md LICENSE]
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.6'

  s.add_dependency 'omniauth', '~> 2.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.5'
end
