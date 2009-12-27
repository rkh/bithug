require 'krb5_auth'

module Bithug::Authentication
  module Kerberos
    def authenticate(username, password)
      begin
        Krb5Auth::Krb5.new.get_init_creds_password(username, password)
      rescue Krb5Auth::Krb5::Exception
        false
      end
    end
  end
end
