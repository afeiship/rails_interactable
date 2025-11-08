# lib/rails_interactable/engine.rb
require 'rails'
require_relative '../rails_interactable'

module RailsInteractable
  class Engine < ::Rails::Engine
    isolate_namespace RailsInteractable

    # 加载插件内部的迁移
    initializer "rails_interactable.load_migrations" do
      config.paths["db/migrate"].expanded.each do |expanded_path|
        Rails.application.config.paths["db/migrate"] << expanded_path
      end
    end

    # 配置初始化
    # 注意：如果配置在插件内部初始化，可能在 dummy app 中被覆盖
    # 更好的方式是让使用者在 config/initializers 中配置
    # initializer "rails_interactable.configure" do |app|
    #   RailsInteractable.interaction_types = {
    #     like: { alias: :liked_by? },
    #     favorite: { alias: :favorited_by? }
    #   }
    # end

    # 混入模块
    initializer "rails_interactable.active_record" do
      ActiveSupport.on_load :active_record do
        include RailsInteractable
      end
    end
  end
end