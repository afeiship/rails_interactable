# lib/rails_interactable/engine.rb
require 'rails'
require_relative '../rails_interactable'

module RailsInteractable
  class Engine < ::Rails::Engine
    isolate_namespace RailsInteractable

    # 配置初始化
    initializer "rails_interactable.configure" do |app|
      # 在这里进行默认配置
      # 也可以通过 Rails.application.config 来接收用户在 config/initializers 中的配置
      RailsInteractable.interaction_types = {
        like: { alias: :liked_by? },
        favorite: { alias: :favorited_by? }
        # 可以添加更多类型
        # comment: {},
        # share: {}
      }
    end

    # 混入模块
    initializer "rails_interactable.active_record" do
      ActiveSupport.on_load :active_record do
        include RailsInteractable
      end
    end
  end
end