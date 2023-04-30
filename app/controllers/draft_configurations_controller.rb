class DraftConfigurationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # ユーザーに対応する、PC構成表(下書き)情報と紐づいたパーツ情報を取得する
    drafts = current_user.draft_configurations.includes(:part)
    # 取得したPC構成表情報のパーツ価格要素とパーツ個数要素を使って、構成表の合計金額を算出する
    @sum_price = drafts.sum { |draft| draft.part.price * draft.quantity }
    # 取得した、PC構成表(下書き)のレコードを1つずつ処理する
    drafts.each do |draft|
      # PC構成表(下書き)に紐づくパーツ情報に関連するパーツタグ名を配列として取得する
      part_tags = draft.part.part_tags.pluck(:name)
      # 対応したパーツジャンルのインスタンス変数にPC構成表(下書き)情報を代入する
      if part_tags.any? { |tag| tag === PartTag::CPU }
        @cpu_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::MEMORY }
        @memory_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::VIDEO_CARD }
        @video_card_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::MOTHER_BOARD }
        @mother_board_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::PC_CASE }
        @pc_case_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::POWER_SUPPLY }
        @power_supply_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::CPU_COOLER }
        @cpu_cooler_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::SSD }
        @ssd_draft = draft
      elsif part_tags.any? { |tag| tag === PartTag::HDD }
        @hdd_draft = draft
      end
    end
    # 構成リストにパーツが無い際の各パーツへのリンク用のパーツ情報を取得する
    @part_for_parts_links = Part.get_top_screen_parts
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
      flash[:notice] = "他のパーツをPC構成リストに追加しましょう。"
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

  # PC構成表(下書き)に存在するパーツのタグ情報を配列にまとめる
  def set_existing_part_tag(existing_configuration)
    part = Part.find_by(id: existing_configuration.part_id)
    existing_part_tags = []
    part.part_tags.each do |part_tag|
      existing_part_tags << part_tag.name
    end
    return existing_part_tags
  end

end
