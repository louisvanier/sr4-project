class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :developer

  def google_oauth2
    handle_callback(provider_name: 'google')
  end

  def facebook
    handle_callback(provider_name: 'facebook')
  end

  def developer
    raise Exception unless Rails.env.development?
    oauth_data = request.env['omniauth.auth'].info
    oauth_data['email'] = oauth_data['first_name'].gsub(' ', '') + '@example.com'
    oauth_data['name'] = oauth_data['first_name'] + ' ' + oauth_data['last_name']
    handle_callback(provider_name: 'developer')
  end

  def failure
    Rails.logger.info("[OMNIAUTH_CALLBACK] failure to authenticate using omniauth")
    redirect_to root_path
  end

  private

  def get_redirection_path(email_address)
    'lobby#index'
  end

  def handle_callback(provider_name:)
    omniauth_data = request.env['omniauth.auth'].info
    @user = User.from_omniauth(
      omniauth_data
    )

    if @user.persisted?
      flash[:notice] = 'Your authentication was successful, an administrator will approve your account'
      sign_in @user, event: :authentication
      redirect_to get_redirection_path(@user.email)
    else
      session["devise.#{provider_name}_data"] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
