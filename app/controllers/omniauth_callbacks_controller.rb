class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_oauth, only: [:vkontakte, :twitter]
  before_action :authorize, only: [:vkontakte, :twitter]

  def twitter
  end

  def vkontakte
  end

  def set_email
    if params[:email].present?
      session[:email] = params[:email]
      authorize
    else
      render template: 'users/email'
    end
  end

  def set_oauth
    auth = request.env['omniauth.auth']
    session[:uid] = auth.uid
    session[:provider] = auth.provider
    session[:email] = auth.info[:email]
  end

  private

  def authorize
    @user = User.find_for_oauth(session)
    if @user
      if @user.persisted?
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      else
        authorization = @user.authorizations.first
        session['devise.authorization'] = { provider: authorization.provider, uid: authorization.uid }
        redirect_to new_user_registration_path
      end
    else
      render template: 'users/email'
    end
  end
end