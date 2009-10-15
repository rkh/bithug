require 'pathname'
require 'user'
require 'repository'
require 'ohm'
$LOAD_PATH.unshift Pathname.new(__FILE__).dirname.join("serve").expand_path.to_s

module Bithug
  module Serve
    require 'access_manager'
    require 'shell'
    require 'exceptions'

    Ohm.connect
  end
end
