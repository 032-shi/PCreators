class PartTag < ApplicationRecord
  has_many :part_tag_maps, dependent: :destroy, foreign_key: 'part_tag_id'
  has_many :parts, through: :part_tag_maps

  # PCパーツ一覧TOP画面(/parts/index)のパーツタグ名を宣言する
  CPU = 'CPU'
  MEMORY = 'メモリー'
  VIDEO_CARD = 'グラフィックボード'
  MOTHER_BOARD = 'マザーボード'
  CPU_COOLER = 'CPUクーラー'
  PC_CASE = 'PCケース'
  POWER_SUPPLY = 'PC電源'
  SSD = 'SSD'
  HDD = 'HDD'
end
