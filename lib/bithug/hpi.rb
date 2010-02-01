require "bithug"

module Bithug::Hpi
  module Repository
    include Bithug::ServiceHelper
    stack Bithug::Git::Repository, Bithug::Svn::Repository
  end

  module User
    include Bithug::ServiceHelper 
    stack Bithug::Local::User, Bithug::Kerberos::User #, Bithug::Ldap::User

    class_methods do

      def login(email)
        username = user_from_mail email
        super(username).tap do |user|
          user.real_name = username.split(".").map { |s| s.capitalize }.join " "
          user.email = email
        end.save
      end

      def authenticate(email, *whatever)
        username = user_from_mail(email) or return false
        super(username, *whatever)
      end

      def user_from_mail(email)
        $1.downcase if email =~ /^([^@]+\.[^@]+)@(student\.)?hpi\.uni-potsdam\.de$/
      end

      def find(hash)
        hash[:name] = user_from_mail(hash[:name]) if user_from_mail(hash[:name])
        super(hash)
      end

    end

  end
end
