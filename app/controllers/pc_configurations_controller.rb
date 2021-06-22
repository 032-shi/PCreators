class PcConfigurationsController < ApplicationController

  def index
    @pc_configurations = PcConfiguration.all
  end

  def show
    @pc_configuration = PcConfiguration.find(params[:id])
  end

  def new
    @pc_configuration = current_user.pc_configurations.new
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

  def create
    @pc_configuration = current_user.pc_configurations.new(pc_configuration_params)
    @pc_configuration.save
    draft_configurations = current_user.draft_configurations
    draft_configurations.each do |draft_configuration|
     @part_configuration = PartConfiguration.new
     @part_configuration.pc_configuration_id = @pc_configuration.id
     @part_configuration.part_id = draft_configuration.part_id
     @part_configuration.quantity = draft_configuration.quantity
     @part_configuration.save
    end
    draft_configurations.destroy_all
    redirect_to pc_configurations_path
  end

  def edit
    @pc_configuration = PcConfiguration.find(params[:id])
  end

  def update
    @pc_configuration = PcConfiguration.find(params[:id])
    if  @post.update(pc_configuration_params)
      redirect_to pc_configuration_path(@pc_configuration.id)
    else
      redirect_to pc_configuration_path(@pc_configuration.id)
    end
  end

  def destroy
    @pc_configuration = PcConfiguration.find(params[:id])
    @pc_configuration.destroy
    redirect_to pc_configurations_path
  end

  private

  def pc_configuration_params
    params.require(:pc_configuration).permit(:title, :image, :body)
  end

end
