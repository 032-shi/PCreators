class PartsController < ApplicationController
  def index
    @parts = Part.all
  end

  def narrowing
    @part_tag_lists = PartTag.all
    @part_tag = PartTag.find(params[:part_tag_id])
    @parts = @part_tag.parts.all
  end
end
