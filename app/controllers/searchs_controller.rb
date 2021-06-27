class SearchsController < ApplicationController
  def search
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    partical(@model, @value)
  end

  private

  def partical(model, value)
    if model == 'post'
      keywords = value.split(/[[:blank:]]+/).select(&:present?)
      @posts = []
      keywords.each do |keyword|
        @posts += Post.where("title LIKE ?", "%#{keyword}%").or(Post.where("body LIKE ?", "%#{keyword}%"))
      end
      @posts.uniq!
    elsif model == 'part'
      keywords = value.split(/[[:blank:]]+/).select(&:present?)
      @part_tags = []
      keywords.each do |keyword|
        @part_tags += PartTag.where("name LIKE ?", "%#{keyword}%")
      end
      @part_tags.uniq!
    end
  end
end
