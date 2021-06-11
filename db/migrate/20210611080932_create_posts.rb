class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|

      t.integer :user_id
      t.string :post_title
      t.string :post_image_id
      t.string :post_body
      t.timestamps null: false
    end
  end
end
