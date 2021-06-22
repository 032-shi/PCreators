class PartConfiguration < ApplicationRecord
  belongs_to :pc_configuration
  belongs_to :part
end
