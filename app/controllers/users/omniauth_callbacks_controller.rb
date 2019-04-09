class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_callback(provider_name: 'google')
  end

  def facebook
    handle_callback(provider_name: 'facebook')
  end

  def failure
    Rails.logger.info("[OMNIAUTH_CALLBACK] failure to authenticate using omniauth")
    redirect_to root_path
  end

  private

  def get_redirection_path(email_address)
    # redirect to some user lobby
  end

  def handle_callback(provider_name:)
    omniauth_data = request.env['omniauth.auth'].info
    @user = User.from_omniauth(
      omniauth_data
    )

    if @user.persisted?
      flash[:notice] = 'Your authentication was successful, an administrator will approve your account' unless @user.approved
      sign_in @user, event: :authentication
      redirect_to get_redirection_path(@user.email)
    else
      session["devise.#{provider_name}_data"] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
