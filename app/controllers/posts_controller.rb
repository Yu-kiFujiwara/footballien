class PostsController < ApplicationController
  before_action :post_find, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  def index
    @user = current_user
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
    @likes = Like.new(user_id: current_user.id, post_id: params[:post_id])
    @like = Like.find_by(user_id: current_user.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path, notice: "投稿しました！"
    else
      redirect_to new_post_path, notice: "内容を確認してください"
    end
  end

  def show
    @comment = @post.comments.build
    @comments = @post.comments
    @comments = @post.comments.includes(:user).all
    @like = Like.new
  end

  def edit
    if @post.user_id == current_user.id
    else
      redirect_to posts_path
    end
  end

  def update
    if @post.user_id == current_user.id
      if @post.update(post_params)
        redirect_to posts_path, notice: "投稿を編集しました"
      else
        redirect_to edit_post_path, notice: "内容を確認してください"
      end
    else
      redirect_to posts_path
    end
  end

  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      redirect_to posts_path
    end
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end

  def post_find
    @post = Post.find(params[:id])
  end
end
