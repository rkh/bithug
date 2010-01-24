require "depgen/depgen"
class Dependencies < Depgen
  github("rkh", :git_ref => "v%s") do
    add "monkey-lib", :version => "0.3.5"
    add "big_band", :version => "0.2.3"
  end
end
