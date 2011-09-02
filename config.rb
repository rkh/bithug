require 'web_tools/middleware/debugger'

Bithug.configure do
  middleware WebTools::Middleware::Debugger
  middleware Rack::Auth::Basic do |username, password|
    Bithug::User.login(username) if Bithug::User.authenticate(username, password)
  end

  use :Maglev
  use :Local
  use :Git
  use :Svn
end
