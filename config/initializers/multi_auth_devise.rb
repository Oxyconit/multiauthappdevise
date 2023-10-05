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
end

class SamlMultiAuthSetup < BaseMultiAuthSetup
  def omniauth_strategy_settings
    # you can add your logic here, for example set options based on URL/params/etc.
    # request.params['saml_idp'] == 'idp1' ? idp1_settings : idp2_settings
    # request.subdomain == 'myprojectname1' ? { aa: 1 } : { aa: 2 }

    {
      # Each field are described with details here: https://github.com/omniauth/omniauth-saml#options
      # Data below are just for example, you need to replace them with your own data.
      # 
      # these data you can find in your IdProvider's metadata XML file. You can fetch these missing details via class:
      # your_issuer_url_xml = 'https://app.onelogin.com/saml/metadata/21bf2959-9dbb-49f1-8f8f-4e246bc0cfd8'
      # data = OneLogin::RubySaml::IdpMetadataParser.new.parse_remote(your_issuer_url_xml)
      # data.idp_sso_service_url
      #
      idp_slo_service_url: "https://mylocaldemo-dev.onelogin.com/trust/saml2/http-redirect/slo/2737275",
      idp_cert_fingerprint: "BB:CC:4B:A4:4E:66:8A:91:84:EE:36:52:04:B4:88:AA:18:35:9C:E1",
      idp_sso_service_url: "https://mylocaldemo-dev.onelogin.com/trust/saml2/http-redirect/sso/c92a7390-5363-475e-ae63-736083af0e84",

      # these data are configured by you(here in this app).
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
    # you can add your logic here, for example set options based on URL/params/etc.
    # request.params['saml_idp'] == 'idp1' ? idp1_settings : idp2_settings
    # request.subdomain == 'myprojectname1' ? { client_id: '1', client_secret: '2' } : { client_id: '3', client_secret: '4' }
    #
    # these data you can find in your Google API Console via https://console.cloud.google.com/apis/credentials
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
