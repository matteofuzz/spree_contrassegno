# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_contrassegno'
  s.version     = '0.1.1'
  s.summary     = 'Spree payment via contrassegno, direct payment to courier'
  s.description = '...'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Matteo Folin'
  s.email             = 'mfolin@f5lab.com'
  s.homepage          = 'http://f5lab.com'
  # s.rubyforge_project = 'actionmailer'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '> 0.9'
  s.add_development_dependency 'rspec-rails'
end

