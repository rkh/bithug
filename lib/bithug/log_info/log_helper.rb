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
  end
end
