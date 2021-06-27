class CreateDraftConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_configurations do |t|

      t.integer :user_id
      t.integer :part_id
      t.integer :quantity
      t.timestamps
    end
  end
end
