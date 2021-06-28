class PcConfigurationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pc_configurations = PcConfiguration.order("created_at DESC").page(params[:page]).per(9)
  end

  def show
    @pc_configuration = PcConfiguration.find(params[:id])
    sum = 0
    existing_configurations = @pc_configuration.part_configurations.all
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

  def new
    @pc_configuration = current_user.pc_configurations.new
    sum = 0
    existing_configurations = current_user.draft_configurations.all
    existing_configurations.each do |existing_configuration|
      sum += existing_configuration.part.price * existing_configuration.quantity
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
    @sum_price = sum
  end

  def create
    @pc_configuration = current_user.pc_configurations.new(pc_configuration_params)
    if @pc_configuration.save
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
    else
      sum = 0
      existing_configurations = current_user.draft_configurations.all
      existing_configurations.each do |existing_configuration|
        sum += existing_configuration.part.price * existing_configuration.quantity
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
      @sum_price = sum
      render :new
    end
  end

  def edit
    @pc_configuration = PcConfiguration.find(params[:id])
    unless @pc_configuration.user_id == current_user.id
      redirect_to pc_configurations_path
    end
  end

  def update
    @pc_configuration = PcConfiguration.find(params[:id])
    if @pc_configuration.user_id != current_user.id #投稿したユーザー以外は、投稿一覧へ遷移させる
      redirect_to pc_configurations_path
    else
      if @pc_configuration.update(pc_configuration_params)
        redirect_to pc_configuration_path(@pc_configuration.id)
      else
        render :edit
      end
    end
  end

  def destroy
    @pc_configuration = PcConfiguration.find(params[:id])
    if @pc_configuration.user_id != current_user.id #投稿したユーザー以外は、投稿一覧へ遷移させる
      redirect_to pc_configurations_path
    else
      @pc_configuration.destroy
      redirect_to pc_configurations_path
    end
  end

  private

  def pc_configuration_params
    params.require(:pc_configuration).permit(:title, :image, :body)
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
