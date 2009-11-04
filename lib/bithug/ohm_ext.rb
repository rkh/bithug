
require 'ohm'

class Ohm::Attributes::Collection
  def clear
    self.each do |item|
      self.delete(item)
    end
  end
end
