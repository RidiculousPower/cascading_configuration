
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController::ExtensionModule do

  before :all do
    @instance = ::Module.new do
      def self.method_in_object_but_not_module
      end
    end
    @instance_controller = ::CascadingConfiguration::Core::InstanceController.new( @instance )
    @ccm = ::CascadingConfiguration::Core::InstanceController::ExtensionModule.new( @instance_controller, :some_configuration )
  end
  
  ################
  #  initialize  #
  ################
  
  it 'has an instance controller' do
    @ccm.instance_controller.should == @instance_controller
  end
  
  it 'has a type name' do
    @ccm.configuration_name.should == :some_configuration
  end
  
  ##################
  #  alias_method  #
  ##################
  
  it 'can pend method aliases' do
    @ccm.alias_method( :alias_name, :method_in_object_but_not_module )
    @instance.respond_to?( :alias_name ).should == false
    @instance.extend( @ccm )
    @instance.respond_to?( :alias_name ).should == true
  end

end
