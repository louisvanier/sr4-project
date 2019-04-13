class Api::V1::TemplatesMatrixUsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def index
    users = Templates::MatrixUser.where(user_id: current_user.id).includes(:matrix_program)
    render json: users.to_json(include: :matrix_program)
  end
end
