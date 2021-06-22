class CreatePartConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :part_configurations do |t|

      t.integer :pc_configuration_id
      t.integer :part_id
      t.integer :quantity
      t.timestamps
    end
  end
end
