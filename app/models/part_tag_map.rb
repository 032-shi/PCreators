class PartTagMap < ApplicationRecord
  belongs_to :part
  belongs_to :part_tag

  validates :part_id, presence: true
  validates :part_tag_id, presence: true
end
