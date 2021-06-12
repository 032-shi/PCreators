class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :post_tags, through: :post_tag_maps
  attachment :post_image
end
