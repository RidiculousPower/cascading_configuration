
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController::ExtensionModule do

  ################
  #  initialize  #
  ################
  
  it 'can create a module for use with an instance for dynamic definition' do
    module ::CascadingConfiguration::Core::InstanceController::ExtensionModule::InitializeMock

      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      Module_instance = ::CascadingConfiguration::Core::InstanceController::ExtensionModule.new( InstanceController, Encapsulation, :some_configuration )

      Module_instance.instance_controller.should == InstanceController
      Module_instance.encapsulation.should == Encapsulation
      Module_instance.configuration_name.should == :some_configuration

    end
  end
  
  ##################
  #  alias_method  #
  ##################
  
  it 'can pend method aliases' do
    module ::CascadingConfiguration::Core::InstanceController::ExtensionModule::AliasMethodMock
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      Module_instance = ::CascadingConfiguration::Core::InstanceController::ExtensionModule.new( InstanceController, Encapsulation, :some_configuration )
      
      Module_instance.alias_method( :alias_name, :method_in_object_but_not_module )
      
      instance = ::Module.new do
        def self.method_in_object_but_not_module
        end
      end
      
      instance.respond_to?( :alias_name ).should == false
      instance.extend( Module_instance )
      instance.respond_to?( :alias_name ).should == true
      
    end
  end

end
