class PostsController < ApplicationController

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_lists = params[:post][:names].split(/[[:blank:]]+/).select(&:present?) #splitで全角及び半角スペースで配列化し、selectで値がある場合のみデータを取得する
    if  @post.save
      @post.save_tag(tag_lists)
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
    @post_comment = PostComment.new
  end

  def narrowing
    @post_tag_lists = PostTag.all
    @post_tag = PostTag.find(params[:post_tag_id])
    @posts = @post_tag.posts.all
  end

  def edit
    @post = Post.find(params[:id])
    post_tag_lists = @post.post_tags
    post_tag_names = [] #以下、タグの初期値の取り出し処理
    post_tag_lists.each do |post_tag_list|
      post_tag = post_tag_list.name
      post_tag_names.push(post_tag)
    end
    @post_tags = post_tag_names.join(" ")
  end

  def update
    @post = Post.find(params[:id])
    tag_lists = params[:post][:names].split(/[[:blank:]]+/).select(&:present?) #新規投稿時と同様の処理
    if  @post.update(post_params)
      @post.save_tag(tag_lists)
      redirect_to post_path(@post.id)
    else
      redirect_to post_path(@post.id)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :image, :body)
  end

  def post_tag_params  #タグ用ストロングパラメータを設定する
    params.require(:post).permit(:names)
  end
end
