class Templates::MatrixUsersController < ApplicationController
  before_action :set_templates_matrix_user, only: [:show, :edit, :update, :destroy]

  # GET /templates/matrix_users
  # GET /templates/matrix_users.json
  def index
    @templates_matrix_users = Templates::MatrixUser.all
  end

  # GET /templates/matrix_users/1
  # GET /templates/matrix_users/1.json
  def show
  end

  # GET /templates/matrix_users/new
  def new
    @templates_matrix_user = Templates::MatrixUser.new(programs: [], name: 'johnny')
    byebug
    puts 'debug'
  end

  # GET /templates/matrix_users/1/edit
  def edit
  end

  # POST /templates/matrix_users
  # POST /templates/matrix_users.json
  def create
    @templates_matrix_user = Templates::MatrixUser.new(templates_matrix_user_params)

    respond_to do |format|
      if @templates_matrix_user.save
        format.html { redirect_to @templates_matrix_user, notice: 'Matrix user was successfully created.' }
        format.json { render :show, status: :created, location: @templates_matrix_user }
      else
        format.html { render :new }
        format.json { render json: @templates_matrix_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/matrix_users/1
  # PATCH/PUT /templates/matrix_users/1.json
  def update
    respond_to do |format|
      if @templates_matrix_user.update(templates_matrix_user_params)
        format.html { redirect_to @templates_matrix_user, notice: 'Matrix user was successfully updated.' }
        format.json { render :show, status: :ok, location: @templates_matrix_user }
      else
        format.html { render :edit }
        format.json { render json: @templates_matrix_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/matrix_users/1
  # DELETE /templates/matrix_users/1.json
  def destroy
    @templates_matrix_user.destroy
    respond_to do |format|
      format.html { redirect_to templates_matrix_users_url, notice: 'Matrix user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_templates_matrix_user
      @templates_matrix_user = Templates::MatrixUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def templates_matrix_user_params
      params.require(:templates_matrix_user).permit(
        :name,
        :reaction,
        :intuition,
        :logic,
        :willpower,
        :computer,
        :cybercombat,
        :data_search,
        :electronic_warfare,
        :hacking,
        programs_attributes: [:program_name, :rating]
      )
    end
end
