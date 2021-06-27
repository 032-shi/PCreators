class PcConfiguration < ApplicationRecord
  belongs_to :user
  has_many :part_configurations, dependent: :destroy
  attachment :image
  
  validates :title, presence: true
  validates :body, presence: true
end
