
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def google_oauth2
    user = User.find_by(email: google_oauth_email)
    if user.present?
      sign_in_and_redirect_user(user, 'Google')
    else
      flash[:alert] = t('devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{google_oauth_email} is not authorized.")
      redirect_to after_omniauth_failure_path_for
    end
  end

  def saml
    user = User.find_by(email: saml_data_response.uid)

    # create user if not exists
    # you can add additional check based on the group name/etc. (saml_data_response_group_name) passed by IdProvider
    if user.nil?
      user = User.create!(
        email: saml_data_response.uid,
        password: SecureRandom.hex(16),
        # role_group: saml_data_response_group_name,
        # first_name: saml_data_response.info.first_name,
        # last_name: saml_data_response.info.last_name
      )
    end

    sign_out_all_scopes
    flash[:success] = t('devise.omniauth_callbacks.success', kind: 'SAML')
    sign_in_and_redirect user, event: :authentication
  end

  private

  def google_oauth_email
    request.env['omniauth.auth']&.info&.email
  end

  def saml_data_response
    request.env['omniauth.auth']
  end

  def saml_data_response_group_name
    # you can fetch any specified attribute from your IdP
    saml_data_response.extra.response_object.attributes['group']
  end

  protected

  def after_omniauth_failure_path_for(_scope_resource = nil)
    root_path
  end

  def after_sign_in_path_for(_scope_resource = nil)
    root_path
  end
end
