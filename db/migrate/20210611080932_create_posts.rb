class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|

      t.integer :user_id
      t.string :title
      t.string :image_id
      t.text :body
      t.timestamps null: false
    end
  end
end
