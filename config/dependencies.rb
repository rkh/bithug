require 'pathname'

module Bithug
  ROOT = Pathname(__FILE__).join('..').expand_path
  $LOAD_PATH.unshift ROOT.join("lib").to_s, *Dir.glob(ROOT.join("vendor/"))
end

require 'dm-core'
#require 'grit'