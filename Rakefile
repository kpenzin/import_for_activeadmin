begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

import './lib/tasks/import_for_activeadmin.rake'

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ImportForActiveadmin'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end






Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task default: :test

require 'rails/generators'
require 'rails/generators/migration'



namespace :import_for_activeadmin do
  desc 'Create model, migration, page in ActiveAdmin and controllers'
  task :install do
    include Rails::Generators::Migration

    migration_template 'migration.rb', File.join('db/migrate', 'create_imports.rb')
    template 'model.rb',               File.join('app/models', 'import.rb')
    template 'import.rb',              File.join('app/admin',  'import.rb')
    template 'assign_fields.html.erb', File.join('app/views/admin/imports', 'assign_fields.html.erb')
    template 'file_report.html.erb',   File.join('app/views/admin/imports', 'file_report.html.erb')
  end
end