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
        @posts += Post.where("title LIKE ?", "%#{keyword}%").or(Post.where("body LIKE ?", "%#{keyword}%")).order("created_at DESC")
      end
      @posts.uniq!
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(9)
      #以下、Ajax通信の場合のみ通過
      return unless request.xhr?
      render "searchs/search_posts_pagenate"
    elsif model == 'part'
      keywords = value.split(/[[:blank:]]+/).select(&:present?)
      part_tags = []
      keywords.each do |keyword|
        part_tags += PartTag.where("name LIKE ?", "%#{keyword}%")
      end
      part_tags.uniq!
      @parts = []
      part_tags.each do |part_tag|
        part_tag.parts.each do |part|
          @parts << part
        end
      end
      @parts.uniq!
      @parts = Kaminari.paginate_array(@parts).page(params[:page]).per(20)
      #以下、Ajax通信の場合のみ通過
      return unless request.xhr?
      render "searchs/search_parts_pagenate"
    end
  end
end
