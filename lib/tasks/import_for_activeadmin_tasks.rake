# desc "Explaining what the task does"
# task :import_for_activeadmin do
#   # Task goes here
# end
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