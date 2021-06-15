class PartsController < ApplicationController
  def index
    part_tag = PartTag.find_by(name: "CPU")
    @parts = part_tag.parts
  end

  def narrowing
    @part_tag_lists = PartTag.all
    @part_tag = PartTag.find(params[:part_tag_id])
    @parts = @part_tag.parts.all
  end
end
