module Bithug::Wrapper
  def available_vcs_wrappers
    Bithug::Wrapper::Git
    Bithug::Wrapper::Svn
  end
end
