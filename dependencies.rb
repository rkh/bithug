require "depgen/depgen"
class Dependencies < Depgen
  github "lsegal", "yard", :version => "0.5.2"
  github "dchelimsky", "rspec", :version => "1.3.0"
  github("rkh", :git_ref => "v%s") do
    add "monkey-lib", :version => "0.3.5"
    add "big_band", :version => "0.2.5"
  end
end
