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
        RailsInteractable::Interaction.where(
          target: self,
          operator: operator,
          interaction_type: type_str
        ).exists?
      end

      # 2. 获取互动者列表: TYPEers
      define_method "#{type_sym}s" do
        # 重用 interactors 方法的逻辑
        interactors(type_str)
      end

      # 2.5. 获取互动者ID列表: TYPE_ids
      define_method "#{type_sym}_ids" do
        # 重用 interactors_ids 方法的逻辑
        interactors_ids(type_str)
      end

      # 3. 获取互动计数: TYPE_count
      define_method "#{type_sym}_count" do
        RailsInteractable::Interaction.where(target: self, interaction_type: type_str).count
      end

      # 4. 添加互动: add_TYPE(operator)
      define_method "add_#{type_sym}" do |operator|
        unless RailsInteractable::Interaction.where(
          target: self,
          operator: operator,
          interaction_type: type_str
        ).exists?
          RailsInteractable::Interaction.create!(
            target: self,
            operator: operator,
            interaction_type: type_str
          )
        end
      end

      # 5. 移除互动: remove_TYPE(operator)
      define_method "remove_#{type_sym}" do |operator|
        interaction = RailsInteractable::Interaction.where(
          target: self,
          operator: operator,
          interaction_type: type_str
        ).first
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
    # 通用方法 - 使用 interaction_type
    def interacted_by?(operator, type)
      RailsInteractable::Interaction.where(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      ).exists?
    end

    # 修改 interactors 方法，移除 joins，避免多态关联加载错误
    def interactors(type)
      # 首先获取所有相关交互的 operator_type 和 operator_id
      operator_data = RailsInteractable::Interaction
                         .where(target: self, interaction_type: type.to_s)
                         .pluck(:operator_type, :operator_id)

      # 按 operator_type 分组
      operators_by_type = operator_data.group_by(&:first).transform_values { |group| group.map(&:last).uniq }

      # 为每种类型批量查询对应的模型实例
      results = []
      operators_by_type.each do |operator_type, operator_ids|
        operator_class = operator_type.constantize
        instances = operator_class.where(id: operator_ids)
        results.concat(instances)
      end

      results
    end

    # 新增：获取互动者ID列表
    def interactors_ids(type)
      RailsInteractable::Interaction
        .where(target: self, interaction_type: type.to_s)
        .pluck(:operator_id)
        .uniq
    end

    def interaction_count(type)
      RailsInteractable::Interaction.where(target: self, interaction_type: type.to_s).count
    end

    # 通用方法
    def add_interaction(operator, type)
      unless RailsInteractable::Interaction.where(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      ).exists?
        RailsInteractable::Interaction.create!(
          target: self,
          operator: operator,
          interaction_type: type.to_s
        )
      end
    end

    def remove_interaction(operator, type)
      interaction = RailsInteractable::Interaction.where(
        target: self,
        operator: operator,
        interaction_type: type.to_s
      ).first
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