# lib/generators/rails_interactable/install_generator.rb
require 'rails/generators'
require 'rails/generators/migration'

module RailsInteractable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.join(File.dirname(__FILE__), 'templates')

    def copy_initializer
      template 'initializer.rb', 'config/initializers/rails_interactable.rb'
    end

    # lib/generators/rails_interactable/install_generator.rb
    def copy_migration
      migration_template 'create_interactions.rb.tt', 'db/migrate/create_interactions.rb'
    end

    private

    def migration_timestamp
      Time.current.strftime("%Y%m%d%H%M%S")
    end

    # ActiveRecord::Generators::Base 会自动提供这个方法，但 Base 需要自己实现
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end
  end
end