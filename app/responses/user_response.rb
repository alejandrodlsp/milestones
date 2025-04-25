class UserResponse < ApplicationResponse
  def initialize(user, includes: [])
    @user = user
    @includes = includes
  end

  def as_json
    {
      id: @user.id,
      first_name: @user.name,
      last_name: @user.last_name,
      avatar: image_url,
      email: @user.email,
      join_date: @user.created_at
    }
  end

  private

  def image_url
    return nil unless @user.image.attached?
    url_for(@user.image)
  end
end
