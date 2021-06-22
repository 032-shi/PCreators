class DraftConfiguration < ApplicationRecord
  belongs_to :user
  belongs_to :part

  def self.honkan
    part = Part.find(90)
    send_part_tags = []
    part.part_tags.each do |part_tag|
      send_part_tags << part_tag.name
    end
    if send_part_tags.any? { |w| w == "CPU" }
      return send_part_tag = "CPU"
    elsif send_part_tags.any? { |w| w == "メモリー" }
      return send_part_tag = "メモリー"
    elsif send_part_tags.any? { |w| w == "グラフィックボード" }
      return send_part_tag = "グラフィックボード"
    elsif send_part_tags.any? { |w| w == "マザーボード" }
      return send_part_tag = "マザーボード"
    elsif send_part_tags.any? { |w| w == "PCケース" }
      return send_part_tag = "PCケース"
    elsif send_part_tags.any? { |w| w == "PC電源" }
      return send_part_tag = "PC電源"
    elsif send_part_tags.any? { |w| w == "CPUクーラー" }
      return send_part_tag = "CPUクーラー"
    elsif send_part_tags.any? { |w| w == "SSD" }
      return send_part_tag = "SSD"
    elsif send_part_tags.any? { |w| w == "HDD" }
      return send_part_tag = "HDD"
    end
  end

def self.henkan
  existing_configurations = DraftConfiguration.all
  parts_id = []
  existing_configurations.each do |existing_configuration|
    parts_id << existing_configuration.part_id
  end
  existing_part_tags = []
  parts = Part.where(id: parts_id)
  parts.each do |part|
    part.part_tags.each do |part_tag|
      existing_part_tags << part_tag.name
    end
  end
  return existing_part_tags
end
end
