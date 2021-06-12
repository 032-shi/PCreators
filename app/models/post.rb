class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :post_tags, through: :post_tag_maps
  attachment :post_image

  def save_post_tag(sent_post_tags)
    current_post_tags = self.post_tags.pluck(:post_tag_name) unless self.post_tags.nil?
    old_post_tags = current_post_tags - sent_post_tags #既存のタグから登録するタグを除く
    new_post_tags = sent_post_tags - current_post_tags #登録するタグから既存のタグを除く

    old_post_tags.each do |old_post_tag| #既存のタグを削除する
      self.post_tags.delete PostTag.find_by(post_tag_name: old_post_tag)
    end

    new_post_tags.each do |new_post_tag| #登録するタグを保存する
      add_tag = PostTag.find_or_create_by(post_tag_name: new_post_tag)
      self.post_tags << add_tag
    end
  end
end
