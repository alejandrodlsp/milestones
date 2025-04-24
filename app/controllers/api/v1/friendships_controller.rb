class Api::V1::FriendshipsController < ApplicationController
  before_action :authorize_access_request!

  def index
    friends_of_friends = user_friends.flat_map do |friend|
      Friendship.where("user_id = ? OR friend_id = ?", friend.id, friend.id)
                .includes(:user, :friend)
                .map { |friendship| friendship.friend_id == friend.id ? friendship.user : friendship.friend }
    end

    current_friends = User.where(id: user_friends.pluck(:id))
    possible_friends = User.where.not(id: user_pending_requests.pluck(:id) + [current_user.id])
    recommended_friends = friends_of_friends.uniq.reject do |friend|
      user_friends.include?(friend) || friend.id == current_user.id
    end

    render json: { 
      friends: current_friends.map { |user| UserResponse.new(user) },
      possible_friends: possible_friends.map { |user| UserResponse.new(user) },
      recommended_from_friends: recommended_friends.map { |user| UserResponse.new(user) }
    }, status: :ok
  end

  def show
    render json: { 
      status: current_user.friendship_status(friend_user),
      friendship: friendship
    }, status: :ok
  end

  def create
    return render_error("There is a pending / rejected friendship with this user") if friendship && friendship.status != 'accepted'
    return render_error('There is already a friendship with this user') if friendship
    return render_error('Cannot befriend yourself') if friend_user == current_user

    new_friendship = Friendship.create(user: current_user, friend: friend_user, status: 'pending')

    if new_friendship.persisted?
      render json: { message: 'Friend request sent.', user: UserResponse.new(friend_user).as_json }, status: :created
    else
      render_error('Could not send friend request.', details: new_friendship.errors.full_messages)
    end
  end

  def update
    return render_error('No pending friend request from this user.', :not_found) unless friendship

    if friendship.update(status: 'accepted')
      render json: { message: 'Friend accepted.', friendship: friendship }, status: :ok
    else
      render_error('Could not accept friend request.', details: friendship.errors.full_messages)
    end
  end

  def destroy
    return render_error('Friendship not found.', :not_found) unless friendship

    if friendship.destroy
      render json: { message: 'Friend removed.' }, status: :ok
    else
      render_error('Could not remove friend.')
    end
  end

  def pending
    pending_requests = current_user.inverse_friendships.where(status: 'pending')
    render json: { users: pending_requests.map { |friendship| UserResponse.new(friendship.user) } }, status: :ok
  end

  def sent
    sent_requests = current_user.friendships.where(status: 'pending')
    render json: { users: sent_requests.map { |friendship| UserResponse.new(friendship.friend) } }, status: :ok
  end

  private

  def user_friends
    @user_friends ||= Friendship.where("(user_id = ? OR friend_id = ?) AND status = ?", current_user.id, current_user.id, 'accepted')
      .includes(:user, :friend)
      .map { |friendship| friendship.friend_id == current_user.id ? friendship.user : friendship.friend }
  end

  def user_pending_requests
    @user_pending_requests ||= Friendship.where("user_id = ? OR friend_id = ?", current_user.id, current_user.id)
      .includes(:user, :friend)
      .map { |friendship| friendship.friend_id == current_user.id ? friendship.user : friendship.friend }
  end

  def friend_user
    @friend_user ||= User.find_by(id: params[:friend_id])
    render_error('User not found.', :not_found) unless @friend_user
    @friend_user
  end

  def friendship
    @friendship ||= Friendship.find_by(user: current_user, friend: friend_user) ||
                    Friendship.find_by(user: friend_user, friend: current_user)
  end
end
