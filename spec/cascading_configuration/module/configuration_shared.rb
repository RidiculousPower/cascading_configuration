# -*- encoding : utf-8 -*-

require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

shared_examples_for ::CascadingConfiguration::Module::Configuration do
  
  ##############
  #  instance  #
  ##############
  
  context '#instance' do
    it 'will return instance associated with configuration' do
      parent_configuration.instance.should be parent_instance
    end
    it 'will be of corresponding type' do
      parent_configuration.should be_a configuration_class
    end
  end

  ############
  #  module  #
  ############

  context '#module' do
    it 'will return configuration module associated with configuration' do
      parent_configuration.module.should be configuration_module
    end
  end

  ##########
  #  name  #
  ##########

  context '#name' do
    it 'initialize should set configuration name' do
      parent_configuration.name.should be configuration_name
    end
  end

  ################
  #  write_name  #
  ################
  
  context '#write_name' do
    context 'when configuration name ends with [A-Za-z0-9_]' do
      it 'initialize should set configuration write name to name by default' do
        parent_configuration.write_name.should == configuration_write_name
      end
    end
    context 'when configuration name ends with [?]' do
      let( :configuration_name ) { :configuration_name? }
      let( :configuration_write_name ) { :_configuration_name= }
      it 'will use the read name' do
        parent_configuration.name.should == configuration_name
      end
      it 'will use the corresponding write name' do
        parent_configuration.write_name.should == configuration_write_name
      end
    end
    context 'when configuration name ends with [!]' do
      let( :configuration_name ) { :configuration_name! }
      let( :configuration_write_name ) { :_configuration_name= }
      it 'will use the read name' do
        parent_configuration.name.should == configuration_name
      end
      it 'will use the corresponding write name' do
        parent_configuration.write_name.should == configuration_write_name
      end
    end
  end
  
  ##################
  #  has_value?    #
  #  value         #
  #  value=        #
  #  clear  #
  ##################

  context '#value, #value=, #has_value?, #clear' do
    context 'when it has no value' do
      it 'will return value' do
        parent_configuration.value.should be nil
      end
      it 'will report no value' do
        parent_configuration.has_value?.should be false
      end
    end
    context 'when it has a value' do
      before :each do
        parent_configuration.value = :some_value
      end
      it 'will return value' do
        parent_configuration.value.should be :some_value
      end
      it 'will report it has a value' do
        parent_configuration.has_value?.should be true
      end
      it 'can remove the value' do
        parent_configuration.clear
        parent_configuration.has_value?.should be false
      end
    end
  end
  
end
