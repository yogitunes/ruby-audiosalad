$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "audiosalad/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "audiosalad"
  s.version     = AudioSalad::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AudioSalad."
  s.description = "TODO: Description of AudioSalad."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.9"
  s.add_runtime_dependency "generic_music_rails"
  s.add_runtime_dependency "httparty"
  
  s.add_development_dependency "sqlite3"
end
