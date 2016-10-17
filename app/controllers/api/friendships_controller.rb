class Api::FriendshipsController < Api::CrudController

  def create
    friendship = Friendship.where({user_id: params[:current_user_id], friend_id: params[:friend_id]})
    friendship = friend || Friendship.where({friend_id: params[:current_user_id], user_id: params[:friend_id]})
    if !friendship
      friendship = current_user.friendships.build(friend_id: params[:friend_id])
      if friendship.save
        render json: {status: "success", status_code: 200, data: friendship.as_json}
      end
    else
      render json: {status: "success", status_code: 200, data: friendship.as_json}
    end
    
  end

end
