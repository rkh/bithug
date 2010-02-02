module Bithug::Wrapper
  def available_vcs_wrappers
    Bithug::Wrapper::Git
    Bithug::Wrapper::GitSvn
  end
end
