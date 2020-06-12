class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    if current_user.id == @room.player_id || current_user.id == @room.owner_id
      @message = Message.new
      @messages = @room.messages
      @owner = User.find_by(id: @room.owner_id)
      @player = User.find_by(id: @room.player_id)
    else
      redirect_to "/"
    end
  end
end
