require 'bithug'

module Bithug
  module Ext
    module Ohm
      ::Ohm::Attributes::Collection.send :include, self
      def clear
        self.each do |item|
          self.delete(item)
        end
      end
    end
  end
end
