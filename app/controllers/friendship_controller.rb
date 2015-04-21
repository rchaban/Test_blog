class FriendshipController < ApplicationController
  before_filter :setup_friends

  def create
    Friendship.request(@user, User.find(params[:friend_id]))
    flash[:info] = 'Friendship request sent!'
    redirect_to users_path
  end

  def index
    redirect_to users_path
  end

  def accept
    p "----------------------- accep -----------------------"
    p @friend
    p @user
    if @user.requested_friends(@friend)
      Friendship.accept(@user, @friend)
      flash[:success] = "Friendship accepted!"
    else
      flash[:info] = "No friendship request."
    end
    redirect_to @friend
  end

  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:info] = "Friendship declined!"
    else
      flash[:info] = "No friendship request."
    end
    redirect_to @user
  end

  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:info] = "Friendship request canceled!"
    else
      flash[:info] = "No request for friendship."
    end
    redirect_to @user
  end

  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:info] = "Friendship deleted!"
    else
      flash[:info] = "You aren't friends."
    end
    redirect_to @user
  end

  private

  def setup_friends
    p "setup_friends"
    @user = current_user
    @friend = User.find_by_id(params[:id])
  end	
end
