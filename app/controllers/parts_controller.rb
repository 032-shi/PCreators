class PartsController < ApplicationController
  def index
  end

  def narrowing
    @part_tag = PartTag.find(params[:part_tag_id])
    @parts = @part_tag.parts.page(params[:page]).per(20)
  end

  def show
    @part = Part.find(params[:id])
    @part_tags = @part.part_tags
    @draft_configuration = DraftConfiguration.new
  end

end
