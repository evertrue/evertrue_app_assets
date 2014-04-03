Gem::Specification.new do |s|
  s.name        = 'evertrue_app_assets'
  s.version     = '0.0.1.alpha'
  s.licenses    = ['MIT']
  s.summary     = 'EverTrue Assets from iTunes API'
  s.description = 'Searches the iTunes API for EverTrue assets'
  s.author      = 'DJ Hartman'
  s.email       = 'dj.hartman@evertrue.com'
  s.files       = ['lib/evertrue_app_assets.rb']
  s.platform    = Gem::Platform::CURRENT

  s.add_dependency 'itunes-search-api', '~> 0'
  s.add_dependency 'httparty', '~> 0.10', '>= 0.10.0'

  # General
  s.add_development_dependency 'bundler', '~> 1.5', '>= 1.5.1'
  s.add_development_dependency 'rake', '~> 10.1', '>= 10.1.1'

  # Release
  s.add_development_dependency 'fury', '~> 0.0', '>= 0.0.5'
end
