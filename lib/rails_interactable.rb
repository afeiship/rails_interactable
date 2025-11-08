# lib/rails_interactable.rb
require "rails_interactable/engine"

module RailsInteractable
  # 存储全局配置
  mattr_accessor :interaction_types, default: {}

  extend ActiveSupport::Concern

  class_methods do
    # 模型只需声明自己是可互动的即可
    def acts_as_interactable
      include InstanceMethods
      # 在模型类被加载时，根据全局配置动态定义方法
      RailsInteractable.interaction_types.each do |type, config|
        define_interaction_methods_for_type(type, config)
      end
    end

    private

    # 动态定义与特定互动类型相关的方法
    def define_interaction_methods_for_type(type, config)
      type_sym = type.to_sym
      type_str = type.to_s

      # 1. 检查互动状态: interacted_by_TYPE?(operator)
      define_method "interacted_by_#{type_sym}?" do |operator|
        Interaction.exists?(
          target: self,
          operator: operator,
          interaction_interaction_type: type_str
        )
      end

      # 2. 获取互动者列表: TYPEers
      define_method "#{type_sym}s" do
        Interaction.joins(:operator)
                   .where(target: self, interaction_type: type_str)
                   .pluck('operator_type', 'operator_id')
                   .map { |otype, oid| otype.constantize.find(oid) }
      end

      # 3. 获取互动计数: TYPE_count
      define_method "#{type_sym}_count" do
        Interaction.where(target: self, interaction_type: type_str).count
      end

      # 4. 添加互动: add_TYPE(operator)
      define_method "add_#{type_sym}" do |operator|
        Interaction.find_or_create_by!(
          target: self,
          operator: operator,
          interaction_type: type_str
        )
      end

      # 5. 移除互动: remove_TYPE(operator)
      define_method "remove_#{type_sym}" do |operator|
        interaction = Interaction.find_by(
          target: self,
          operator: operator,
          interaction_type: type_str
        )
        interaction&.destroy
      end

      # 6. 切换互动: toggle_TYPE(operator)
      define_method "toggle_#{type_sym}" do |operator|
        if send("interacted_by_#{type_sym}?", operator)
          send("remove_#{type_sym}", operator)
        else
          send("add_#{type_sym}", operator)
        end
      end

      # 7. 根据配置添加别名等
      if config && config[:alias]
        alias_method config[:alias], "interacted_by_#{type_sym}?"
      end
    end
  end

  module InstanceMethods
    # 通用方法
    def interacted_by?(operator, type)
      Interaction.exists?(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      )
    end

    def interactors(type)
      Interaction.joins(:operator)
                 .where(target: self, interaction_type: type.to_s)
                 .pluck('operator_type', 'operator_id')
                 .map { |otype, oid| otype.constantize.find(oid) }
    end

    def interaction_count(type)
      Interaction.where(target: self, interaction_type: type.to_s).count
    end

    def add_interaction(operator, type)
      Interaction.find_or_create_by!(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      )
    end

    def remove_interaction(operator, type)
      interaction = Interaction.find_by(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      )
      interaction&.destroy
    end

    def toggle_interaction(operator, type)
      if interacted_by?(operator, type)
        remove_interaction(operator, type)
      else
        add_interaction(operator, type)
      end
    end
  end
end