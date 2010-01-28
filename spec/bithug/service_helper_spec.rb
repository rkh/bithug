require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::ServiceHelper do
  
  def service(&block)
    Module.new { include Bithug::ServiceHelper }.tap { |m| m.class_eval(&block) if block }
  end
  
  def service_method(name, &block)
    service { define_method(name, &block) }
  end

  def service_class_method(name, &block)
    service { class_methods { define_method(name, &block) } }
  end
  
  it 'should dispatch instance methods in correct order' do
    first_service  = service_method(:something) { [:foo] + super }
    second_service = service_method(:something) { [:bar] + super }
    bottom_service = service_method(:something) { [:blah] }
    klass = Class.new
    [first_service, second_service, bottom_service].reverse_each do |service|
      klass.send :include, service
    end
    klass.new.something.should == [:foo, :bar, :blah]
  end
  
  it 'should dispatch class methods in correct order' do
    first_service  = service_class_method(:something) { [:foo] + super }
    second_service = service_class_method(:something) { [:bar] + super }
    bottom_service = service_class_method(:something) { [:blah] }
    klass = Class.new
    [first_service, second_service, bottom_service].reverse_each do |service|
      klass.send :include, service
    end
    klass.something.should == [:foo, :bar, :blah]
  end
  
end