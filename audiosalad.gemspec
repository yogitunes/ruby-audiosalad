$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "audiosalad/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "audiosalad"
  s.version     = AudioSalad::VERSION
  s.authors     = ["Daniel Staudigel"]
  s.email       = ["daniel@yogitunes.com"]
  s.homepage    = "http://github.com/yogitunes/ruby-audiosalad"
  s.summary     = "A gem for interacting with the AudioSalad API."
  s.description = "A gem for interacting with the audiosalad API."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"
  s.add_runtime_dependency "generic_music_rails"
  s.add_runtime_dependency "httparty"
  
  s.add_development_dependency "sqlite3"
end
