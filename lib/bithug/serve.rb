require 'pathname'
require 'user'
require 'repository'
$LOAD_PATH.unshift Pathname.new(__FILE__).dirname.join("serve").expand_path.to_s

module Bithug
  module Serve
    require 'access_manager'
    require 'shell'
  end
end
