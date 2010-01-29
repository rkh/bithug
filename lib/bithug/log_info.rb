# This module wraps up the different kinds
# of logs we keep 
module Bithug::LogInfo
  autoload :CommitInfo,   'bithug/log_info/commit_info'
  autoload :FollowInfo,   'bithug/log_info/follow_info'
  autoload :ForkInfo,     'bithug/log_info/fork_info'
  autoload :LogHelper,    'bithug/log_info/log_helper'
  autoload :RightsInfo,   'bithug/log_info/rights_info'
end
