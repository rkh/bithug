require 'bithug'
require 'ohm'

module Bithug::Ext
  module Ohm
    ::Ohm::Attributes::Collection.send :include, self
    def clear
      self.each do |item|
        self.delete(item)
      end
    end
  end
end
