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
    binding.pry
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save!
    redirect_to posts_path, notice: "投稿しました！"
  end

  def show
    @comment = @post.comments.build
    @comments = @post.comments
    @comments = @post.comments.includes(:user).all
    @like = Like.new
  end

  def edit
  end

  def update
    if @post.user_id == current_user.id
      @post.update!(post_params)
      redirect_to posts_path, notice: "投稿を編集しました"
    else
      redirect_to posts_path
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end

  def post_find
    @post = Post.find(params[:id])
  end
end
