class Api::FriendshipsController < ApiController

  def create
    friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if friendship.save
      render json: {status: "success", status_code: 200, data: friendship.as_json}
    end
  end

end
