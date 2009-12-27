# A configuration of Bithug for the HPI
module Bithug::Hpi

  class Repository < Bithug::Repository
    include Bithug::Repositories::Svn
    include Bithug::Repositories::Git
  end
  
  class User < Bitug::User
    attribute :real_name
    attribute :email
  
    include Bithug::Authentication::Local
    include Bithug::Authentication::LDAP
    include Bithug::Authentication::Kerberos
  end
end
