$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "catalogillo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "catalogillo"
  s.version     = Catalogillo::VERSION
  s.authors     = ["Edwin Cruz"]
  s.email       = ["softr8@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Solr powered catalogs"
  s.description = "Mountable engine active record independent to generate catalogs pages using solr"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "sunspot_rails", ">= 2.0"
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'bootstrap-sass', '>= 2.3'
  s.add_dependency "jquery-rails"
  s.add_dependency "versionist", '>= 1.0'
  s.add_development_dependency 'rspec-rails'
end
