require 'rails/generators'
require 'rails/generators/migration'

module ImportForActiveadmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Generates migrations and other"

    end
  end
end