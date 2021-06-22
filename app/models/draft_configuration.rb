class DraftConfiguration < ApplicationRecord
  belongs_to :user
  belongs_to :part

end
