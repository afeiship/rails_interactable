# app/models/rails_interactable/interaction.rb
module RailsInteractable
  class Interaction < ApplicationRecord
    self.table_name = 'interactions'

    # 禁用 STI
    self.inheritance_column = :_type_disabled

    belongs_to :operator, polymorphic: true
    belongs_to :target, polymorphic: true

    # 确保 interaction_type 被识别为属性
    attribute :interaction_type, :string

    validates :interaction_type, presence: true
    validates :operator, presence: true
    validates :target, presence: true
    validates :operator_type, :operator_id, :target_type, :target_id, :interaction_type, presence: true
    validates :operator_id, uniqueness: { scope: [:operator_type, :target_type, :target_id, :interaction_type] }

    # 定义 type 和 type= 方法来代理到 interaction_type
    # 这样任何尝试读写 'type' 的地方都会操作 'interaction_type'
    def type
      interaction_type
    end

    def type=(value)
      self.interaction_type = value
    end
  end
end