# lib/generators/rails_interactable/templates/create_interactions.rb.tt
class CreateInteractions < ActiveRecord::Migration[8.1]
  def change
    create_table :rails_interactions do |t|
      # 使用 interaction_type 而不是 type
      t.string :interaction_type, null: false
      t.references :operator, polymorphic: true, null: false, index: { name: 'index_interactions_on_op_type_and_op_id' }
      t.references :target, polymorphic: true, null: false, index: { name: 'index_interactions_on_tgt_type_and_tgt_id' }

      t.timestamps
    end

    add_index :interactions, [:operator_type, :operator_id, :interaction_type, :target_type, :target_id], unique: true, name: 'index_unique_interaction'
  end
end