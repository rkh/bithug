Bithug.configure do
  # use Twitter, :except => Repository
  # use Ldap, :host => "ldap.com", :port => 10
  use :Local
  use :Svn
  use :Git
end