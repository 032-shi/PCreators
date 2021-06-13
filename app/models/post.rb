class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :post_tags, through: :post_tag_maps
  attachment :image

  def save_tag(tag_lists)
    current_tags = self.post_tags.pluck(:names) unless self.post_tags.nil?
    old_tags = current_tags - tag_lists #既存のタグから登録するタグを除く
    new_tags = tag_lists - current_tags #登録するタグから既存のタグを除く

    old_tags.each do |old_tag| #既存のタグを削除する
      self.post_tags.delete PostTag.find_by(name: old_tag)
    end

    new_tags.each do |new_tag| #登録するタグを保存する
      add_tag = PostTag.find_or_create_by(name: new_tag)
      self.post_tags << add_tag
    end
  end
end
