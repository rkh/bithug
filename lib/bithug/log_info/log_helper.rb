module Bithug::LogInfo
  module LogHelper
    include Bithug::ServiceHelper

    attribute :date_time

    def prevent_change(on)
      return if new?
      # If we haven't been commited to storage, we can still change
      if attributes.include? on
        raise RuntimeError, "Must not change logs!" unless send(on).nil?
      else
        raise RuntimeError, "Must not change logs!" unless send(on).first.nil?
      end
    end

    def timestamp
      Time.at(date_time.to_i)
    end

    def recent(num = 10)
      self.class.all.sort_by(:date_time, :order => "ASC")[0..num]
    end

    class_methods do
      def create(*args)
        super.tap do |log|
          log.date_time ||= Time.now.to_i
          log.save
        end
      end
    end
  end
end
