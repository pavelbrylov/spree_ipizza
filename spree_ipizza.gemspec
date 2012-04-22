Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ipizza'
  s.version     = '0.1'
  s.summary     = 'Ipizza support for Spree'
  s.description = 'Ipizza is payment protocol which is used mostly in Estonia'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Pavel Brylov'
  s.email             = 'pavel@brylov.info'
  s.homepage          = 'http://www.brylov.info'
  s.rubyforge_project = 'spree_ipizza'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 0.70')
  s.add_dependency('ipizza-rails', '>= 0.0.6')
end
