
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController::SupportModule do

  ################
  #  initialize  #
  ################
  
  it 'can create a module for use with an instance for dynamic definition' do
    module ::CascadingConfiguration::Core::InstanceController::SupportModule::InitializeMock
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Encapsulation = ::CascadingConfiguration::Core::Encapsulation.new( :some_encapsulation )
      Module_instance = ::CascadingConfiguration::Core::InstanceController::SupportModule.new( InstanceController, Encapsulation, :some_type )
      ForInstance.ancestors.include?( Module_instance ).should == false
      ForInstance.is_a?( Module_instance ).should == false
    end
  end

  ###################
  #  super_modules  #
  ###################
  
  it 'can return the first super module on each parent tree' do
    module ::CascadingConfiguration::Core::InstanceController::SuperModulesMock

      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      CCMMock = ::Module.new do
        def self.create_configuration( encapsulation, instance, this_name )
        end
        def self.initialize_configuration( encapsulation, instance, this_name )
        end
      end

      # set up hierarchy
      ForInstance_A = ::Module.new
      Encapsulation.register_configuration( ForInstance_A, :some_configuration, CCMMock )
      InstanceController_A = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_A )
      
      Module_A = InstanceController_A.create_support( :some_type )
      ForInstance_B1 = ::Module.new do
        include ForInstance_A
      end
      Encapsulation.register_configuration( ForInstance_B1, :some_other_configuration, CCMMock )
      Encapsulation.register_child_for_parent( ForInstance_B1, ForInstance_A )
      ForInstance_B2 = ::Module.new do
        include ForInstance_A
      end
      Encapsulation.register_child_for_parent( ForInstance_B2, ForInstance_A )
      ForInstance_C1 = ::Module.new do
        include ForInstance_B1
      end
      Encapsulation.register_configuration( ForInstance_C1, :yet_another_configuration, CCMMock )
      Encapsulation.register_child_for_parent( ForInstance_C1, ForInstance_B1 )
      ForInstance_C2 = ::Module.new do
        include ForInstance_B1
      end
      Encapsulation.register_child_for_parent( ForInstance_C2, ForInstance_B1 )
      ForInstance_D = ::Module.new do
        include ForInstance_B2
        include ForInstance_C1
        include ForInstance_C2
      end
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_B2 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C1 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C2 )
      Module_A.super_modules.empty?.should == true
      InstanceController_B2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B2 )
      Module_B2 = InstanceController_B2.create_support( :some_type )
      Module_B2.super_modules.should == [ Module_A ]
      InstanceController_C1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C1 )
      Module_C1 = InstanceController_C1.create_support( :some_type )
      Module_B2.super_modules.should == [ Module_A ]
      Module_C1.super_modules.should == [ Module_A ]
      InstanceController_C2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C2 )
      Module_C2 = InstanceController_C2.create_support( :some_type )
      Module_B2.super_modules.should == [ Module_A ]
      Module_C1.super_modules.should == [ Module_A ]
      Module_C2.super_modules.should == [ Module_A ]
      InstanceController_B1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B1 )
      Module_B1 = InstanceController_B1.create_support( :some_type )
      Module_B1.super_modules.should == [ Module_A ]
      Module_B2.super_modules.should == [ Module_A ]
      Module_C1.super_modules.should == [ Module_B1 ]
      Module_C2.super_modules.should == [ Module_B1 ]
      InstanceController_D = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_D )
      Module_D = InstanceController_D.create_support( :some_type )
      Module_B1.super_modules.should == [ Module_A ]
      Module_B2.super_modules.should == [ Module_A ]
      Module_C1.super_modules.should == [ Module_B1 ]
      Module_C2.super_modules.should == [ Module_B1 ]
      Module_D.super_modules.should == [ Module_C2, Module_C1, Module_B2 ]
    end
  end
  
  ###################
  #  child_modules  #
  ###################
  
  it 'can return the first child module on each child tree' do
    module ::CascadingConfiguration::Core::InstanceController::ChildModulesMock

      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      # set up hierarchy
      ForInstance_A = ::Module.new do
        # we have to mock the method bc that's how the module determines if it has a configuration defined
        # since we don't know whether a configuration value has been set yet
        attr_accessor :some_configuration
      end
      InstanceController_A = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_A )
      Module_A = InstanceController_A.create_support( :some_type )
      ForInstance_B1 = ::Module.new do
        # we have to mock the method bc that's how the module determines if it has a configuration defined
        # since we don't know whether a configuration value has been set yet
        attr_accessor :some_other_configuration
        include ForInstance_A
      end
      Encapsulation.register_child_for_parent( ForInstance_B1, ForInstance_A )
      ForInstance_B2 = ::Module.new do
        include ForInstance_A
      end
      Encapsulation.register_child_for_parent( ForInstance_B2, ForInstance_A )
      ForInstance_C1 = ::Module.new do
        include ForInstance_B1
        attr_accessor :yet_another_configuration
      end
      Encapsulation.register_child_for_parent( ForInstance_C1, ForInstance_B1 )
      ForInstance_C2 = ::Module.new do
        include ForInstance_B1
      end
      Encapsulation.register_child_for_parent( ForInstance_C2, ForInstance_B1 )
      ForInstance_D = ::Module.new do
        include ForInstance_B2
        include ForInstance_C1
        include ForInstance_C2
      end
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_B2 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C1 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C2 )
      InstanceController_B2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B2 )
      Module_B2 = InstanceController_B2.create_support( :some_type )
      InstanceController_C1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C1 )
      Module_C1 = InstanceController_C1.create_support( :some_type )
      InstanceController_C2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C2 )
      Module_C2 = InstanceController_C2.create_support( :some_type )
      InstanceController_B1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B1 )
      Module_B1 = InstanceController_B1.create_support( :some_type )
      InstanceController_D = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_D )
      Module_D = InstanceController_D.create_support( :some_type )
      Module_A.child_modules.should == [ Module_B1, Module_B2 ]
      Module_B1.child_modules.should == [ Module_C1, Module_C2 ]
      Module_B2.child_modules.should == [ Module_D ]
      Module_C1.child_modules.should == [ Module_D ]
      Module_C2.child_modules.should == [ Module_D ]
      Module_D.child_modules.empty?.should == true
    end
  end
  
  ###########################################
  #  cascade_new_support_for_child_modules  #
  ###########################################
  
  it 'can return the first child module on each child tree' do
    module ::CascadingConfiguration::Core::InstanceController::CascadeNewSupportForChildModulesMock

      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      # set up hierarchy
      ForInstance_A = ::Module.new do
        # we have to mock the method bc that's how the module determines if it has a configuration defined
        # since we don't know whether a configuration value has been set yet
        attr_accessor :some_configuration
      end
      InstanceController_A = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_A )
      Module_A = InstanceController_A.create_support( :some_type )
      ForInstance_B1 = ::Module.new do
        # we have to mock the method bc that's how the module determines if it has a configuration defined
        # since we don't know whether a configuration value has been set yet
        attr_accessor :some_other_configuration
        include ForInstance_A
      end
      Encapsulation.register_child_for_parent( ForInstance_B1, ForInstance_A )
      ForInstance_B2 = ::Module.new do
        include ForInstance_A
      end
      Encapsulation.register_child_for_parent( ForInstance_B2, ForInstance_A )
      ForInstance_C1 = ::Module.new do
        include ForInstance_B1
        attr_accessor :yet_another_configuration
      end
      Encapsulation.register_child_for_parent( ForInstance_C1, ForInstance_B1 )
      ForInstance_C2 = ::Module.new do
        include ForInstance_B1
      end
      Encapsulation.register_child_for_parent( ForInstance_C2, ForInstance_B1 )
      ForInstance_D = ::Module.new do
        include ForInstance_B2
        include ForInstance_C1
        include ForInstance_C2
      end
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_B2 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C1 )
      Encapsulation.register_child_for_parent( ForInstance_D, ForInstance_C2 )
      Module_A.child_modules.empty?.should == true
      InstanceController_C2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C2 )
      Module_C2 = InstanceController_C2.create_support( :some_type )
      Module_A.child_modules.should == [ Module_C2 ]
      Module_C2.child_modules.empty?.should == true
      InstanceController_B2 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B2 )
      Module_B2 = InstanceController_B2.create_support( :some_type )
      Module_A.child_modules.should == [ Module_C2, Module_B2 ]
      Module_B2.child_modules.empty?.should == true
      Module_C2.child_modules.empty?.should == true
      InstanceController_C1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_C1 )
      Module_C1 = InstanceController_C1.create_support( :some_type )
      Module_A.child_modules.should == [ Module_C1, Module_C2, Module_B2 ]
      Module_B2.child_modules.empty?.should == true
      Module_C1.child_modules.empty?.should == true
      Module_C2.child_modules.empty?.should == true
      InstanceController_D = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_D )
      Module_D = InstanceController_D.create_support( :some_type )
      Module_A.child_modules.should == [ Module_C1, Module_C2, Module_B2 ]
      Module_B2.child_modules.should == [ Module_D ]
      Module_C1.child_modules.should == [ Module_D ]
      Module_C2.child_modules.should == [ Module_D ]
      Module_D.child_modules.empty?.should == true
      InstanceController_B1 = ::CascadingConfiguration::Core::InstanceController.new( ForInstance_B1 )
      Module_B1 = InstanceController_B1.create_support( :some_type )
      Module_A.child_modules.should == [ Module_B1, Module_B2 ]
      Module_B1.child_modules.should == [ Module_C1, Module_C2 ]
      Module_B2.child_modules.should == [ Module_D ]
      Module_C1.child_modules.should == [ Module_D ]
      Module_C2.child_modules.should == [ Module_D ]
      Module_D.child_modules.empty?.should == true
    end
  end
  
  ###################
  #  define_method  #
  #  alias_method   #
  #  remove_method  #
  #  undef_method   #
  ###################
  
  it 'can define a method in the configuration module, ensuring the module exists first' do
    module ::CascadingConfiguration::Core::InstanceController::DefineAliasRemoveUndefMock
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Module_instance = InstanceController.create_support( :some_type )
      Module_instance.define_method( :some_method ) do
        return :some_method
      end
      Module_instance.method_defined?( :some_method ).should == true
      Module_instance.alias_method( :some_alias, :some_method )
      Module_instance.method_defined?( :some_method ).should == true
      Module_instance.method_defined?( :some_alias ).should == true
      Module_instance.remove_method( :some_alias ).should == true
      Module_instance.method_defined?( :some_alias ).should == false
      Module_instance.remove_method( :some_alias ).should == false
      Module_instance.undef_method( :some_method ).should == true
      Module_instance.method_defined?( :some_method ).should == false
      Module_instance.undef_method( :some_method ).should == false
    end
  end

end
