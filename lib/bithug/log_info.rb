# This module wraps up the different kinds
# of logs we keep 
module Bithug::LogInfo
  autoload :CommitInfo,   'bithug/log_info/commit_info'
  autoload :FollowInfo,   'bithug/log_info/follow_info'
  autoload :ForkInfo,     'bithug/log_info/fork_info'
  autoload :LogHelper,    'bithug/log_info/log_helper'
  autoload :RightsInfo,   'bithug/log_info/rights_info'

  def self.recent(from_set, num = 10)
    from_set.sort_by(:date_time, :order => "ASC")[0..num]
  end
end
