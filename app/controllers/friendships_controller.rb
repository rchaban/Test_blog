class FriendshipsController < ApplicationController
  before_filter :setup_friends

  def create
    Friendship.request(@user, @friend)
    flash[:notice] = "Friend request sent."
    redirect_to current_user
  end

  def accept
    if @user.inverse_friendships.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.name} accepted!"
    else
      flash[:notice] = "No friendship request from #{@friend.name}."
    end 
    redirect_to current_user
  end

  def decline
    if @user.inverse_friendships.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.name} declined"
    else
      flash[:notice] = "No friendship request from #{@friend.name}."
    end
    redirect_to current_user
  end

  def cancel
    if @user.inverse_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship with #{@friend.name}"
    end
    redirect_to current_user
  end

  def destroy
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.name} deleted!"
    else
      flash[:notice] = "You aren't friends with #{@friend.name}"
      redirect_to current_user
    end
  end

  private

  def setup_friends
    @user = current_user
    @friend = User.find_by_name(params[:id])
  end
end
