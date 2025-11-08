# lib/generators/rails_interactable/install_generator.rb
require 'rails/generators'

module RailsInteractable
  class InstallGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), 'templates')

    def copy_initializer
      template 'initializer.rb', 'config/initializers/rails_interactable.rb'
    end

    def copy_migration
      migration_template 'create_interactions.rb', "db/migrate/#{migration_timestamp}_create_interactions.rb"
    end

    private

    def migration_timestamp
      Time.current.strftime("%Y%m%d%H%M%S")
    end
  end
end