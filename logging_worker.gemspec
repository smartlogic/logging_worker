$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "logging_worker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "logging_worker"
  s.version     = LoggingWorker::VERSION
  s.authors     = ["Eric Oestrich"]
  s.email       = ["eric@oestrich.org"]
  s.homepage    = "http://smartlogic.io"
  s.summary     = "Save background worker runs"
  s.description = "Save background worker runs to the database"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "pg", "~> 0.17"

  s.add_development_dependency "rspec-rails", "~> 2.14"
  s.add_development_dependency "sidekiq", "~> 3.3"
  s.add_development_dependency "pry", "~> 0.10"

  s.test_files = Dir["spec/**/*"]
end
