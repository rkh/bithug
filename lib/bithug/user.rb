require "bithug"

# A user of Bithug - nice and pretty
class Bithug::User < Ohm::Model
  attribute :name
  set :following, User
  set :followers, User
  set :keys, Key
  set :repositories, Repository

  index :name

  def validate
    assert_present :name
  end

  class << self
    # The method at the end of the authentication chain
    def authenticate(username, password, options = {})
      false
    end

    # The method to be called if an authentication succeeded
    def login(username)
      User.find(:name => username).first || User.create(:name => username)
    end
  end
end
