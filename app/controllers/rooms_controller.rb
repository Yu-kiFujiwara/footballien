class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id]) #ルーム情報の取得
    @message = Message.new #新規メッセージ投稿
    @messages = @room.messages #このルームのメッセージを全て取得

    @owner = User.find_by(id: @room.owner_id)
    @player = User.find_by(id: @room.player_id)
  end
end
