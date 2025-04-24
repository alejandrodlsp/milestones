module Milestones
  class FetchFromFriendsService < ApplicationService
    MAX_MILESTONES = 10

    attr_accessor :user
    
    def initialize(user)
      @user = user
    end

    def call
      fetch_from_friends
    end

    private

    def fetch_from_friends
      friend_milestones = Milestone.where(user_id: friends.pluck(:id)).limit(MAX_MILESTONES)

      friend_milestones.map do |milestone|
        MilestoneResponse.new(milestone, user).as_json
      end
    end

    def friends
      user.all_friends
    end
  end
end