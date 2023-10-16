# Sample Rails app with Devise, Google OAuth2 and SAML multi-auth implementation

This is a sample Ruby on Rails application that shows you how to set up authentication and authorization using Devise,
Google OAuth2 and SAML. Each authentication method can be configured separately and is multi-auth capable.
Reviewing the commits may be interesting for you to see how the setup was done.

Full article about the sample implementation here: https://blog.oxyconit.com/how-to-setup-simple-multi-auth-for-saml-and-oauth2-using-rails-and-devise/

## Getting Started

These instructions will get you up and running with a copy of the project on your local machine for development and testing purposes.

### Prerequisites

Please ensure your system is running:

- Ruby 3.2.2
- Rails 7.1.0
- PostgreSQL

### Installing

First, clone the repository. After that, install the gems using `bundle install`.

Then, create the database and run the migrations:

```bash
rails db:create
rails db:migrate
```
Then you can start the server with the domain adapter:

```bash
ROOT_DOMAIN="$(ifconfig -l | xargs -n1 ipconfig getifaddr).nip.io:3000" rails s -b 0.0.0.0 
```

And go to the app via http://your-local-ip-computer.nip.io:3000

### SAML and Google OAuth2 Configuration Details

See [multi_auth_devise.rb](config%2Fmulti_auth_devise.rb)

### License
This project is licensed under the MIT License.

## Greetings
Greetings to the authors of omniauth, omniauth-google-oauth2, omniauth-saml, devise and all other gems used in️ this project ♥️ 