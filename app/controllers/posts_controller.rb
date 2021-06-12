class PostsController < ApplicationController

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    post_tag_list = params[:post][:post_tag_name].split(/[[:blank:]]+/).select(&:present?) #splitで全角及び半角スペースで配列化し、selectで値がある場合のみデータを取得する
    if  @post.save
      @post.save_post_tag(post_tag_list)
      redirect_to posts_path
    else
      redirect_to posts_path
    end
  end

  def index
    @posts = Post.all
    @post_tag_lists = PostTag.all
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.post_tags
  end

  def narrowing
    @post_tag_lists = PostTag.all
    @post_tag = PostTag.find(params[:post_tag_id])
    @posts = @post_tag.posts.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:post_title, :post_image, :post_body)
  end

  def post_tag_params  #タグ用ストロングパラメータを設定する
    params.require(:post).permit(:post_tag_names)
  end
end
