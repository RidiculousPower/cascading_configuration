
require_relative '../../../../lib/cascading-configuration.rb'

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

end
