class Users::SessionsController < Devise::SessionsController
  def destroy
    # save the saml_uid and saml_session_index in the session when destroying directly from SAML IdProvider
    saml_uid = session['saml_uid']
    saml_session_index = session['saml_session_index']

    super do
      session['saml_uid'] = saml_uid
      session['saml_session_index'] = saml_session_index
    end
  end

  protected

  def after_sign_out_path_for(_resource_or_scope)
    if session['saml_uid'] && session['saml_session_index'] # && saml_config.idp_slo_service_url.present? # make sure 'idp_slo_service_url' is configured!
      user_saml_omniauth_authorize_path + '/spslo'
    else
      new_user_session_path
    end
  end
end
