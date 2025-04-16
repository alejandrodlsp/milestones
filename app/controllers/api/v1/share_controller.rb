class Api::V1::ShareController < ActionController::Base
  def milestone
    @milestone = Milestone.find(params[:id])
    render layout: false
  end
end