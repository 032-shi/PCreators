class PartsController < ApplicationController
  def index
    # CPUのタグの設定
    @cpu_tag = PartTag.find_by(name: PartTag::CPU)
    # メモリータグの設定
    @memory_tag = PartTag.find_by(name: PartTag::MEMORY)
    # グラフィックボードタグの設定
    @video_card_tag = PartTag.find_by(name: PartTag::VIDEO_CARD)
    # マザーボードタグの設定
    @mother_board_tag = PartTag.find_by(name: PartTag::MOTHER_BOARD)
    # CPUクーラータグの設定
    @cpu_cooler_tag = PartTag.find_by(name: PartTag::CPU_COOLER)
    # PCケースタグの設定
    @pc_case_tag = PartTag.find_by(name: PartTag::PC_CASE)
    # PC電源タグの設定
    @power_supply_tag = PartTag.find_by(name: PartTag::POWER_SUPPLY)
    # SSDタグの設定
    @ssd_tag = PartTag.find_by(name: PartTag::SSD)
    # HDDタグの設定
    @hdd_tag = PartTag.find_by(name: PartTag::HDD)
  end

  def narrowing
    sort = params[:sort] || "created_at DESC"
    @part_tag = PartTag.find(params[:part_tag_id])
    @parts = @part_tag.parts.page(params[:page]).per(20).order(sort)
    #以下、Ajax通信の場合のみ通過
    return unless request.xhr?
    render "parts/narrowing_pagenate"
  end

  def show
    @part = Part.find(params[:id])
    @part_tags = @part.part_tags
    @draft_configuration = DraftConfiguration.new
  end

end
