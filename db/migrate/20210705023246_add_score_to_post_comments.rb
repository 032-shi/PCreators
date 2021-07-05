class AddScoreToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_column :post_comments, :score, :decimal, precision: 5, scale: 3
  end
end
