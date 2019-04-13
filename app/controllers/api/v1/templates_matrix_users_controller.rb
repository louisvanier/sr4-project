class Api::V1::TemplatesMatrixUsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def index
    render json: Templates::MatrixUser.where(user_id: current_user.id)
  end
end
