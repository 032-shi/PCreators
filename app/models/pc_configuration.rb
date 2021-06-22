class PcConfiguration < ApplicationRecord
  belongs_to :user
  has_many :pc_configurations, dependent: :destroy
  attachment :image
end
