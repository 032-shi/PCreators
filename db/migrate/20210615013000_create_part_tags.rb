class CreatePartTags < ActiveRecord::Migration[5.2]
  def change
    create_table :part_tags do |t|

      t.string :name
      t.timestamps
    end
  end
end
