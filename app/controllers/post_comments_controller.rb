class PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.save
    render :index
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    if @post_comment.user_id != current_user.id #コメントを入力したユーザー以外は、投稿一覧へ遷移させる
      redirect_to posts_path
    else
      @post_comment.destroy
      render :index
    end
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
