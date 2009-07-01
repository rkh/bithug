require 'bithug'
require 'bcrypt'

# This agent authenticates against the 
# local database
 class LocalAuthenticationAgent
  def authenticate(username, password)
    user = User.get(username)
    return nil if user.nil?
    BCrypt::Password.new(user.password) == password
  end

  def register(username, password)
    user = User.new
    user.attributes = {:name => username, :password => password}
    user.save!
    user
  end

  def update(username, details)
    if details[:password] == details[:repeated_password]
      user = User.get(username) || register(username, details[:password])
      user = nil unless user.update(details)
    end
    user
  end
end
