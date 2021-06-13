class CreateParts < ActiveRecord::Migration[5.2]
  def change
    create_table :parts do |t|

      t.string :name
      t.string :genre
      t.string :spec
      t.string :manufacturer
      t.integer :price
      t.string :image
      t.timestamps
    end
  end
end
