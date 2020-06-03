class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.id == current_user.id
      if @user.update(user_params)
        redirect_to  "/users/#{@user.id}", notice: "プロフィールを更新しました"
      else
        redirect_to edit_user_path, notice: "内容を確認してください"
      end
    else
      redirect_to "/users/#{@user.id}"
    end

  end

  def following
    @user = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end

  private
  def user_params
    params.require(:user).permit(:name, :location, :age, :introduction)
  end
end
