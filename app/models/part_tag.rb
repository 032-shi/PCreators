class PartTag < ApplicationRecord
  has_many :part_tag_maps, dependent: :destroy, foreign_key: 'part_tag_id'
  has_many :parts, through: :part_tag_maps
end
