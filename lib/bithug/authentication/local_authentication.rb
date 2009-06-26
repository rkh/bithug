require 'bithug'
require 'bcrypt'

# This agent authenticates against the 
# local database
 class LocalAuthenticationAgent
  def authenticate username, password
    user = User.get(username)
    return nil if user.nil?
    password = BCrypt::Password.new(user.password)
  end

  def register(username, password)
    User.create!(:name => username,
      :password => password)
  end
end
