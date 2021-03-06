class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order("created_at DESC").page(params[:posts_page]).per(5)
    @pc_configurations = @user.pc_configurations.order("created_at DESC").page(params[:pc_configurations_page]).per(5)
    #以下、Ajax通信の場合のみ通過
    return unless request.xhr?
    #渡ってきた"type"によって読み込むjsファイルが変わる
    case params[:type]
    when 'post_index', 'pc_configuration'
      render "users/#{params[:type]}"
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to posts_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.id != current_user.id #対象ユーザーがログインユーザーでない場合は、投稿一覧へ遷移させる
      redirect_to  posts_path
    else
      if @user.update(user_params)
        redirect_to user_path(@user.id)
      else
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
