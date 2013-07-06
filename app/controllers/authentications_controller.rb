class AuthenticationsController < Devise::RegistrationsController

  def all
    omniauth = request.env["omniauth.auth"]
    user = User.find_or_create_by_email(omniauth.info.email)
    authentication = Authentication.from_omniauth(omniauth)

    if authentication.persisted?
      user.authentications << authentication
      user.update_attribute('email', omniauth.info.email)
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
