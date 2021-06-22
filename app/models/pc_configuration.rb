class PcConfiguration < ApplicationRecord
  belongs_to :user
  has_many :part_configurations, dependent: :destroy
  attachment :image
end
