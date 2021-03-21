class Api::V1::TemplatesMatrixUsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def index
    users = Templates::MatrixUser.where(user_id: current_user.id).includes(:matrix_program)
    render json: users.to_json(include: :matrix_program)
  end

  def create
    new_user = Templates::MatrixUser.new
    new_user.assign_attributes(template_matrix_user_params)
    new_user.user = current_user
    render json: new_user.save
  end

  def template_matrix_user_params
    params.fetch(:template_matrix_user)
      .permit(
        :name,
        :reaction,
        :intuition,
        :logic,
        :willpower,
        :computer,
        :cybercombat,
        :data_search,
        :electronic_warfare,
        :hacking
      )
  end
end
