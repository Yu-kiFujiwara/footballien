class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
    @owners = []
    @players = []
    @users.each do |u|
      if u.job == 'owner'
        @owners << u
      elsif u.job == 'player'
        @players << u
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    @users = User.all
    if current_user == @user # マイページ表示時
      if current_user.job == 'owner' # オーナーログイン時
        @rs = Room.all
        @rooms = []
        @rs.each do |r|
          if r.owner_id == current_user.id
            if r.messages.present?
              @rooms << r
            end
            @players = []
            
            @rooms.each do |r|
              player = User.find_by(id: r.player_id)
              @players << player
            end
          end
        end
      elsif current_user.job == 'player' # プレイヤーログイン時
        @rs = Room.all
        @rooms = []
        @rs.each do |r|
          if r.player_id == current_user.id
            if r.messages.present?
              @rooms << r
            end
            @owners = []
            @rooms.each do |r|
              owner = User.find_by(id: r.owner_id)
              @owners << owner
            end
          end
        end
      end
    else # 他のユーザーページ表示時
      if current_user.job == 'owner' # オーナーログイン時
        @room = Room.find_by(owner_id: current_user.id, player_id: @user.id)
        if @room.present?
        else
          @room = Room.create(owner_id: current_user.id, player_id: @user.id)
        end
      elsif current_user.job == 'player' # プレイヤーログイン時
        @room = Room.find_by(player_id: current_user.id, owner_id: @user.id)
        if @room.present?
        else
          @room = Room.create(player_id: current_user.id, owner_id: @user.id)
        end
      end
    end
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
    params.require(:user).permit(:name, :location, :age, :introduction, :image)
  end
end
