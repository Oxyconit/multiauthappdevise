class BaseMultiAuthSetup
  def self.call(env)
    new(env).setup
  end

  def initialize(env)
    @env = env
  end

  def setup
    @env['omniauth.strategy'].options.merge!(omniauth_strategy_settings)
  end

  def omniauth_strategy_settings
    raise NotImplementedError
  end
end

class SamlMultiAuthSetup < BaseMultiAuthSetup
  def omniauth_strategy_settings
    # You can add your own logic here, e.g. set options based on URL/params/etc.
    # request.params['saml_idp'] == 'idp1' ? idp1_settings : idp2_settings
    # request.subdomain == 'myprojectname1' ? { aa: 1 } : { aa: 2 }

    {
      # You can find this data in your IdProvider's metadata XML file. You can retrieve these missing details using that code:
      # your_issuer_url_xml = 'https://app.onelogin.com/saml/metadata/21bf2959-9dbb-49f1-8f8f-4e246bc0cfd8'
      # data = OneLogin::RubySaml::IdpMetadataParser.new.parse_remote(your_issuer_url_xml)
      # data.idp_sso_service_url
      #
      # Each field is described in detail here: https://github.com/omniauth/omniauth-saml#options
      # idp_slo_service_url: 'https://myappnamedemo-dev.onelogin.com/trust/saml2/http-redirect/slo/2687489', # This field is not required, but it is nice to support it.
      idp_cert_fingerprint: '17:FE:F0:46:65:43:15:69:5F:A5:C0:00:56:6A:50:45:83:B4:63:54', # SHA1 fingerprint of the IdP signing certificate
      idp_sso_service_url: "https://dev-93536331.okta.com/app/dev-93536331_mydemosample12_1/exkceus6zpxWJI2I75d7/sso/saml",

      # This data is configured by you (here, in this file).
      sp_entity_id: 'your-appname',
      allowed_clock_drift: 5,
      slo_default_relay_state: "/users/sign_in",
      request_attributes: [:name, :first_name, :last_name, :email],
      name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
      single_logout_service_url: "http://192.168.1.45.nip.io:3000/users/auth/saml/slo",
      assertion_consumer_service_url: 'http://192.168.1.45.nip.io:3000/users/auth/saml/callback',
      # skip_recipient_check: true, # specified recipient URL(same as assertion_consumer_service_url) in your IdProvider | default: false
    }
  end
end

class GoogleOauth2Setup < BaseMultiAuthSetup
  def omniauth_strategy_settings
    # You can add your own logic here, e.g. set options based on URL/params/etc.
    # request.params['saml_idp'] == 'idp1' ? idp1_settings : idp2_settings
    # request.subdomain == 'myprojectname1' ? { client_id: '1', client_secret: '2' } : { client_id: '3', client_secret: '4' }
    #
    # You can find this data in your Google API Console at https://console.cloud.google.com/apis/credentials.
    {
      client_id: '445905005724-h150pka3q8ko3c16ch5mlftuf3333jt4.apps.googleusercontent.com',
      client_secret: '98SCSPX-0wf6BqvfEqAVlAZRn8boZdNZsZ_e'
    }
  end
end

Devise.setup do |config|
  config.omniauth :saml, setup: SamlMultiAuthSetup
  config.omniauth :google_oauth2, setup: GoogleOauth2Setup
end
