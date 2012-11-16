
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration do

  before :all do

    @configuration_module = ::Module.new
    @module_instance = ::Module.new
    @object_instance = ::Object
    @instance = ::Object.new
    
  end

  before :each do
    
    configuration_class = ::CascadingConfiguration::Core::Module::Configuration
    
    @module_configuration = configuration_class.new( @module_instance, @configuration_module, :configuration_name )
    @object_configuration = configuration_class.new( @object_instance, @configuration_module, :object_configuration_name?, :object_configuration= )
    @instance_configuration = configuration_class.new( @instance, @configuration_module, :configuration_name )
    
  end
  
  ##############
  #  instance  #
  ##############
  
  it 'initialize should set instance' do
    @module_configuration.instance.should == @module_instance
  end

  ############
  #  module  #
  ############

  it 'initialize should set configuration module' do
    @module_configuration.module.should == @configuration_module
  end

  ##########
  #  name  #
  ##########

  it 'initialize should set configuration name' do
    @module_configuration.name.should == :configuration_name
  end

  ################
  #  write_name  #
  ################
  
  it 'initialize should set configuration write name to name by default' do
    @module_configuration.write_name.should == :configuration_name=
  end

  it 'initialize should set configuration write name if specified' do
    @object_configuration.name.should == :object_configuration_name?
    @object_configuration.write_name.should == :object_configuration=
  end

  #############################
  #  initialize_for_instance  #
  #############################
  
  it 'initialize should extend configurations for Class instances' do
    @module_configuration.is_a?( ::CascadingConfiguration::Core::Module::Configuration::ModuleConfiguration ).should == true
  end
  
  it 'initialize should extend configurations for Module instances' do
    @object_configuration.is_a?( ::CascadingConfiguration::Core::Module::Configuration::ClassConfiguration ).should == true
  end
  
  it 'initialize should extend configurations for instances' do
    @instance_configuration.is_a?( ::CascadingConfiguration::Core::Module::Configuration::InstanceConfiguration ).should == true
  end

  it 'initialize should extend configurations for the Class object' do
    class_configuration = ::CascadingConfiguration::Core::Module::Configuration.new( ::Class, @configuration_module, :configuration_name )
    class_configuration.is_a?( ::CascadingConfiguration::Core::Module::Configuration::ClassConfiguration ).should == true
  end

  ##################
  #  has_value?    #
  #  value         #
  #  value=        #
  #  remove_value  #
  ##################

  it 'starts without a value' do
    @module_configuration.has_value?.should == false
  end

  it 'tracks when a value has been set (even if set to nil)' do
    @module_configuration.value = :some_value
    @module_configuration.has_value?.should == true
    @module_configuration.value.should == :some_value
  end
  
  it 'can remove a value (beyond setting it to nil)' do
    @module_configuration.value = :some_value
    @module_configuration.remove_value
    @module_configuration.has_value?.should == false
    @module_configuration.value.should == nil
  end
  
end
