require "ohm"

module Bithug
  class User < Ohm::Model
    attribute :name
    set :keys

    index :name

    def validate
      assert_present :name
    end

    def self.find(attrs, value)
      result = super(attrs, value).first || self.create(attrs.to_sym => value) 
      [result]
    end
  end
end