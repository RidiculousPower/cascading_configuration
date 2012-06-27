
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Module::InheritingValues do

  ########################################
  #  get_configuration_searching_upward  #
  ########################################

  it 'can get the first defined configuration searching up the module configuration inheritance chain' do
    module ::CascadingConfiguration::Core::Module::InheritingValues::GetConfigurationSearchingUpwardMock
      
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      CCM = ::CascadingConfiguration::Core::Module::InheritingValues.new( 'configuration' )
            
      Instance_A = ::Module.new
      Encapsulation.register_configuration( Instance_A, :some_configuration, CCM )
      Instance_B = ::Module.new do
        include Instance_A
      end
      Encapsulation.register_child_for_parent( Instance_B, Instance_A )
      Encapsulation.register_configuration( Instance_B, :some_other_configuration, CCM )
      Instance_C1 = ::Module.new do
        include Instance_B
      end
      Encapsulation.register_child_for_parent( Instance_C1, Instance_B )
      Encapsulation.register_configuration( Instance_C1, :yet_another_configuration, CCM )
      Instance_C2 = ::Module.new do
        include Instance_B
      end
      Encapsulation.register_child_for_parent( Instance_C2, Instance_B )
      Instance_D = ::Module.new do
        include Instance_C1
        include Instance_C2
      end
      Encapsulation.register_child_for_parent( Instance_D, Instance_C1 )
      Encapsulation.register_child_for_parent( Instance_D, Instance_C2 )
      
      Encapsulation.set_configuration( Instance_A, :some_configuration, :some_value )
      Encapsulation.set_configuration( Instance_B, :some_other_configuration, :some_other_value )
      
      CCM.module_eval do
        get_configuration_searching_upward( Encapsulation, Instance_B, :some_configuration ).should == :some_value
        get_configuration_searching_upward( Encapsulation, Instance_B, :some_other_configuration ).should == :some_other_value
        get_configuration_searching_upward( Encapsulation, Instance_C1, :some_configuration ).should == :some_value
        get_configuration_searching_upward( Encapsulation, Instance_C1, :some_other_configuration ).should == :some_other_value
        Encapsulation.set_configuration( Instance_C1, :yet_another_configuration, :another_value )
        get_configuration_searching_upward( Encapsulation, Instance_C1, :yet_another_configuration ).should == :another_value
        get_configuration_searching_upward( Encapsulation, Instance_C2, :some_configuration ).should == :some_value
        get_configuration_searching_upward( Encapsulation, Instance_C2, :some_other_configuration ).should == :some_other_value
        get_configuration_searching_upward( Encapsulation, Instance_D, :some_configuration ).should == :some_value
        get_configuration_searching_upward( Encapsulation, Instance_D, :some_other_configuration ).should == :some_other_value
        get_configuration_searching_upward( Encapsulation, Instance_D, :yet_another_configuration ).should == :another_value
      end
      
    end    
  end

  #####################
  #  setter           #
  #  getter           #
  #  instance_setter  #
  #  instance_getter  #
  #####################
  
  it 'can set and get values' do
    module ::CascadingConfiguration::Core::Module::InheritingValues::SetterGetterMock
      
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      
      CCM = ::CascadingConfiguration::Core::Module::InheritingValues.new( 'configuration' )
      
      CCM.method( :setter ).should == CCM.method( :instance_setter )
      CCM.method( :getter ).should == CCM.method( :instance_getter )
      
      CCM.getter( Encapsulation, ForInstance, :some_configuration ).should == nil
      CCM.setter( Encapsulation, ForInstance, :some_configuration, :some_value )
      CCM.getter( Encapsulation, ForInstance, :some_configuration ).should == :some_value
      
    end
  end
  
end
