# -*- encoding : utf-8 -*-

require_relative '../../lib/cascading_configuration.rb'

require_relative '../support/named_class_and_module.rb'

describe CascadingConfiguration::Value do

  let( :instance ) do
    instance = ::Module.new
    instance.name( :ValueInstance )
    instance.module_eval { include ::CascadingConfiguration::Value }
    instance.attr_value( :cascading_value ) { |value| value + 1 }
    instance
  end
  
  let( :sub_instance ) do
    sub_instance = ::Module.new
    sub_instance.name( :ValueSubInstance )
    _instance = instance
    sub_instance.module_eval { include _instance }
    sub_instance
  end
  
  ################
  #  attr_value  #
  ################

  context '#attr_value' do
    before( :each ) { sub_instance }
    it 'creates a cascading value' do
      instance.cascading_value = 1
      sub_instance.cascading_value.should == 2
    end
  end

end
