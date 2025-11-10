# app/models/rails_interactable/interaction.rb
module RailsInteractable
  class Interaction < ApplicationRecord
    self.table_name = 'rails_interactions'

    belongs_to :operator, polymorphic: true
    belongs_to :target, polymorphic: true

    validates :interaction_type, presence: true
    validates :operator, presence: true
    validates :target, presence: true
    validates :operator_type, :operator_id, :target_type, :target_id, :interaction_type, presence: true
    validates :operator_id, uniqueness: { scope: [:operator_type, :target_type, :target_id, :interaction_type] }
  end
end