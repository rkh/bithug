module Bithug::LogInfo
  module LogHelper
    def prevent_change(on)
      return if new?
      # If we haven't been commited to storage, we can still change
      if attributes.include? on
        raise RuntimeError, "Must not change logs!" unless send(on).nil?
      else
        raise RuntimeError, "Must not change logs!" unless send(on).first.nil?
      end
    end

    def recent(num = 10)
      self.class.all.sort_by(:date_time, :order => "ASC")[0..num]
    end
  end
end
