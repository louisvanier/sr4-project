class LobbyController < ApplicationController
  before_action :authenticate_user!, except: [:sign_in]
  def index
  end

  def sign_in
  end
end
