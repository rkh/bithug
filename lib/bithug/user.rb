require "bithug"

module Bithug
  
  class AbstractUser
    include DataMapper::Resource

    property  :name,          String, :required => true, :key => true
    has n,    :following,     'Bithug::User'
    has n,    :followers,     'Bithug::User'
    has n,    :keys,          'Bithug::Key'
    has n,    :repositories,  'Bithug::Repository'
  end
  
  class User < AbstractUser
  end

  # A user of Bithug - nice and pretty
  class AbstractUser
    # The method at the end of the authentication chain
    def self.authenticate(username, password, options = {})
      false
    end

    # The method to be called if an authentication succeeded
    def self.login(username)
      Bithug::User.find(:name => username).first || Bithug::User.create(:name => username)
    end
  end

end
