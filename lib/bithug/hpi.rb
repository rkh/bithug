require "bithug"

module Bithug::Hpi
  module Repository
    include Bithug::ServiceHelper
    stack Bithug::Git::Repository, Bithug::Svn::Repository
  end

  module User
    include Bithug::ServiceHelper 
    stack Bithug::Kerberos::User, Bithug::Local::User#, Bithug::Ldap::User
    
    def login(username)
      super
      self.real_name = username.split(".").join " "
    end

  end
end
