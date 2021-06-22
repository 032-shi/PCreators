class DraftConfiguration < ApplicationRecord
  belongs_to :user
  belongs_to :part

def self.henkan
  existing_configurations = current_user.draft_configurations.all
  existing_configurations.each do |existing_configuration|
    part_id = existing_configuration.part_id
    part = Part.find_by(id: part_id)
    existing_part_tags = []
    part.part_tags.each do |part_tag|
      existing_part_tags << part_tag.name
    end
    if existing_part_tags.any? { |w| w == "CPU" }
      @cpu_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "メモリー" }
      @memory_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "グラフィックボード" }
      @gpu_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "マザーボード" }
      @mb_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "PCケース" }
      @case_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "PC電源" }
      @power_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "CPUクーラー" }
      @cooler_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "SSD" }
      @ssd_existing_configuration = existing_configuration
    elsif existing_part_tags.any? { |w| w == "HDD" }
      @hdd_existing_configuration = existing_configuration
    end
  end
end
end
