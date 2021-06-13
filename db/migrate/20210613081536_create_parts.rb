class CreateParts < ActiveRecord::Migration[5.2]
  def change
    create_table :parts do |t|

      t.string :part_name
      t.string :part_genre
      t.string :part_spec
      t.string :manufacturer
      t.integer :price
      t.string :part_image
      t.timestamps
    end
  end
end
