# This uses krb5-auth to do it's job, unless we're using JRuby
# Then SimpleKrb5 is used, which goes through FFI

module Bithug::Kerberos
  module User
    include Bithug::ServiceHelper

    class_methods do
      def authenticate(username, password)
        if RUBY_ENGINE == "jruby"
          require 'simple-krb5'
          SimpleKrb5.authenticate(username, password) || super
        else
          require 'krb5-auth'
          begin
            Krb5Auth::Krb5.new.get_init_creds_password(username, password)
          rescue Krb5Auth::Krb5::Exception
            super
          end
        end
      end
    end

  end
end
