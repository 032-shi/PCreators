class PartsController < ApplicationController
  def index
    # パーツ一覧TOP画面のパーツ情報を取得する
    @top_screen_parts = Part.get_top_screen_parts
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
