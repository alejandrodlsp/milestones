class ListResponse
  def initialize(list, current_user, includes: [])
    @list = list
    @current_user = current_user
    @includes = includes
  end

  def as_json
    data = {
      id: @list.id,
      name: @list.name,
      description: @list.description,
    }

    data[:user] = UserResponse.new(@list.user).as_json if @includes.include?(:user) && @list.user
    data[:milestones] = milestones if @includes.include?(:milestones)

    data
  end

  private

  def milestones
    @_milestones ||= @list.milestones.map do |milestone| 
      MilestoneResponse.new(milestone, @current_user).as_json
    end
  end
end
