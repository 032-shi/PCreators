class DraftConfigurationsController < ApplicationController

  def index
    existing_configurations = current_user.draft_configurations.all
    sum = 0
    existing_configurations.each do |existing_configuration|
      sum += existing_configuration.part.price * existing_configuration.quantity
      existing_part_tags = set_existing_part_tag(existing_configuration)
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
    @sum_price = sum
  end

  def create
    @part = Part.find(params[:part_id])
    @draft_configuration = current_user.draft_configurations.new
    @draft_configuration.quantity = 1
    @draft_configuration.part_id = @part.id
    send_draft_tag = set_send_draft_tag(@part) #以下にインスタンスメソッドを定義
    existing_configurations = current_user.draft_configurations.all
    existing_draft_tags = set_existing_draft_tag(existing_configurations) #以下にインスタンスメソッドを定義
    if existing_draft_tags.any? { |w| w == send_draft_tag }
      @part = Part.find(params[:part_id])
      @part_tags = @part.part_tags
      redirect_to part_path(params[:part_id])
    else
      @draft_configuration.save
      redirect_to draft_configurations_path
    end
  end

  def update
    @draft_configuration = DraftConfiguration.find(params[:id])
    @draft_configuration.update(draft_configuration_params)
    redirect_to draft_configurations_path
  end

  def destroy
    @draft_configuration = DraftConfiguration.find(params[:id])
    @draft_configuration.destroy
    redirect_to draft_configurations_path
  end

  def destroy_all
    @draft_configuration = current_user.draft_configurations
    @draft_configuration.destroy_all
    redirect_to draft_configurations_path
  end

  private

  def draft_configuration_params
    params.require(:draft_configuration).permit(:quantity)
  end

  def set_send_draft_tag(part)
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

  def set_existing_draft_tag(existing_configurations)
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

  def set_existing_part_tag(existing_configuration)
    part_id = existing_configuration.part_id
    part = Part.find_by(id: part_id)
    existing_part_tags = []
    part.part_tags.each do |part_tag|
      return existing_part_tags << part_tag.name
    end
  end

end
