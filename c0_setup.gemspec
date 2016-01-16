Gem::Specification.new do |s|
  s.name        = 'c0_setup'
  s.version     = '0.0.1'
  s.date        = '2016-01-16'
  s.homepage = 'https://github.com/rbrigden'
  s.summary     = "An unofficial setup utility for C0, a subset of C used to teach 15-122 @ CMU"
  s.description = "Setup C0 compiler and interpreter (cc0 and coin)"
  s.executables << 'c0_setup'
  s.authors     = ["Ryan Brigden"]
  s.email       = 'rbrigden@cmu.edu'
  s.files       = ["lib/c0_setup.rb", "cc0", "coin"]
end
