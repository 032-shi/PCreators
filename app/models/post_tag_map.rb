class PostTagMap < ApplicationRecord
  belongs_to :post
  belongs_to :post_tag

  validates :post_id, presence: true
  validates :post_tag_id, presence: true
end
