require "bithug"

module Bithug::Hpi
  module Repository
    include ServiceHelper
    stack Git::Repository, Svn::Repository
  end

  module User
    include ServiceHelper
    property  :real_name, String
    property  :email,     String
    stack Kerberos::User, Ldap::User, Local::User
    Ldap.setup
    Local.setup
  end
end
