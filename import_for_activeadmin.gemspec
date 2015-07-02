$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'import_for_activeadmin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'import_for_activeadmin'
  s.version     = ImportForActiveadmin::VERSION
  s.authors     = ['k.penzin']
  s.email       = ['k.penzin@writex.ru']
  s.homepage    = '123'
  s.summary     = 'Summary of ImportForActiveadmin.'
  s.description = 'Description of ImportForActiveadmin.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.1'

  s.add_development_dependency 'mysql2'
end
