class CreatePartTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :part_tag_maps do |t|

      t.references :part, foreign_key: true
      t.references :part_tag, foreign_key: true
      t.timestamps
    end
  end
end
