
require_relative '../../../lib/cascading-configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController do

  ##############################
  #  initialize                #
  #  instance                  #
  #  self.instance_controller  #
  ##############################
  
  it 'can initialize for an instance' do
    module ::CascadingConfiguration::Core::InstanceController::InitializeMock
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      InstanceController.instance.should == ForInstance
      ForInstance::Controller.should == InstanceController
      ::CascadingConfiguration::Core::InstanceController.instance_controller( ForInstance ).should == InstanceController
      for_instance = ::Object.new
      instance_controller = ::CascadingConfiguration::Core::InstanceController.new( for_instance )
      instance_controller.instance.should == for_instance
    end
  end

  ####################################
  #  initialize_inheriting_instance  #
  ####################################
  
  it 'causes the instance it extends to be enabled for managing inheritable support modules' do
    module ::CascadingConfiguration::Core::InstanceController::InheritanceMock
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      AnotherModule = ::Module.new do
        include ForInstance
      end
      #AnotherAnotherModule = ::Module.new do
      #  include AnotherModule
      #end
      #Encapsulation.parents( AnotherAnotherModule ).include?( AnotherModule ).should == true
    end
  end
  
  ###########################
  #  add_extension_modules  #
  #  extension_modules      #
  ###########################
  
  it 'can declare and retrieve extension modules for a configuration name on instance in an encapsulation' do
    module ::CascadingConfiguration::Core::InstanceController::AddExtensionModulesMock
    
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      
      module SomeModuleA
      end
      module SomeModuleB
      end
      module SomeModuleC
      end
      
      InstanceController.add_extension_modules( :some_configuration, Encapsulation, SomeModuleA, SomeModuleB, SomeModuleC ) do 
        def some_other_stuff
        end
      end
      extension_modules = InstanceController.extension_modules( :some_configuration, Encapsulation )
      extension_modules.count.should == 4
    end
  end
  
  ##############################
  #  extension_modules_upward  #
  ##############################

  it 'can get an array of extension modules ' do
    module ::CascadingConfiguration::Core::InstanceController::ExtensionModulesUpwardMock

      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      CCMMock = ::Module.new do
        def self.create_configuration( encapsulation, instance, this_name )
        end
        def self.initialize_configuration( encapsulation, instance, this_name )
        end
      end

      Instance_A = ::Module.new
      InstanceController_A = ::CascadingConfiguration::Core::InstanceController.new( Instance_A )
      Encapsulation.register_configuration( Instance_A, :some_configuration, CCMMock )
      ExtensionModule_A1 = ::Module.new
      ExtensionModule_A2 = ::Module.new
      InstanceController_A.add_extension_modules( :some_configuration, Encapsulation, ExtensionModule_A1, ExtensionModule_A2 ) do
        def some_other_stuff
        end        
      end
      InstanceController_A.extension_modules( :some_configuration ).count.should == 3
      InstanceController_A.extension_modules_upward( :some_configuration ).should == [ InstanceController_A::Default_some_configuration, ExtensionModule_A2, ExtensionModule_A1 ]


      Instance_B = ::Module.new
      Encapsulation.register_child_for_parent( Instance_B, Instance_A )
  
      Instance_C = ::Module.new
      InstanceController_C = ::CascadingConfiguration::Core::InstanceController.new( Instance_C )
      Encapsulation.register_child_for_parent( Instance_C, Instance_B )
      ExtensionModule_C1 = ::Module.new
      InstanceController_C.add_extension_modules( :some_configuration, Encapsulation, ExtensionModule_C1 ) do
        def some_other_stuff
        end        
      end
      InstanceController_C.extension_modules_upward( :some_configuration ).should == [ InstanceController_C::Default_some_configuration, ExtensionModule_C1, InstanceController_A::Default_some_configuration, ExtensionModule_A2, ExtensionModule_A1 ]

      InstanceController_B = ::CascadingConfiguration::Core::InstanceController.new( Instance_B )
      InstanceController_B.extension_modules_upward( :some_configuration ).should == [ InstanceController_A::Default_some_configuration, ExtensionModule_A2, ExtensionModule_A1 ]
      
    end
  end
  
  ####################
  #  create_support  #
  #  support         #
  ####################

  it 'can manage creation and return of module instances' do
    module ::CascadingConfiguration::Core::InstanceController::CreateSupportMock
      
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )

      # should_include
      ModuleInstance_Include = InstanceController.create_support( :some_type1, Encapsulation, nil, true, false, false, false )
      InstanceController.support( :some_type1 ).should == ModuleInstance_Include
      ForInstance.ancestors.include?( ModuleInstance_Include ).should == true
      ForInstance.is_a?( ModuleInstance_Include ).should == false
      InstanceController.cascade_includes.include?( ModuleInstance_Include ).should == false
      InstanceController.cascade_extends.include?( ModuleInstance_Include ).should == false
      
      # should_extend
      ModuleInstance_Extend = InstanceController.create_support( :some_type2, Encapsulation, false, nil, true, false, false )
      InstanceController.support( :some_type2 ).should == ModuleInstance_Extend
      ForInstance.ancestors.include?( ModuleInstance_Extend ).should == false
      ForInstance.is_a?( ModuleInstance_Extend ).should == true
      InstanceController.cascade_includes.include?( ModuleInstance_Extend ).should == false
      InstanceController.cascade_extends.include?( ModuleInstance_Extend ).should == false
      
      # should_cascade_includes
      ModuleInstance_CascadeIncludes = InstanceController.create_support( :some_type3, Encapsulation, false, nil, false, true, false )
      InstanceController.support( :some_type3 ).should == ModuleInstance_CascadeIncludes
      ForInstance.ancestors.include?( ModuleInstance_CascadeIncludes ).should == false
      ForInstance.is_a?( ModuleInstance_CascadeIncludes ).should == false
      InstanceController.cascade_includes.include?( ModuleInstance_CascadeIncludes ).should == true
      InstanceController.cascade_extends.include?( ModuleInstance_CascadeIncludes ).should == false
      
      # should_cascade_extends
      ModuleInstance_CascadeExtends = InstanceController.create_support( :some_type4, Encapsulation, nil, false, false, false, true )
      InstanceController.support( :some_type4 ).should == ModuleInstance_CascadeExtends
      ForInstance.ancestors.include?( ModuleInstance_CascadeExtends ).should == false
      ForInstance.is_a?( ModuleInstance_CascadeExtends ).should == false
      InstanceController.cascade_includes.include?( ModuleInstance_CascadeExtends ).should == false
      InstanceController.cascade_extends.include?( ModuleInstance_CascadeExtends ).should == true
      
      AnotherModule_IncludeA = ::Module.new do
        include ForInstance
        ancestors.include?( ModuleInstance_CascadeIncludes ).should == true
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == true
      end
      AnotherModule_IncludeB = ::Module.new do
        include AnotherModule_IncludeA
        ancestors.include?( ModuleInstance_CascadeIncludes ).should == true
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == true
      end
      AnotherModule_IncludeC = ::Module.new do
        include AnotherModule_IncludeB
        ancestors.include?( ModuleInstance_CascadeIncludes ).should == true
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == true
      end
      AnotherModule_ClassInclude = ::Class.new do
        include AnotherModule_IncludeC
        ancestors.include?( ModuleInstance_CascadeIncludes ).should == true
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == true
      end

      AnotherModule_ExtendA = ::Module.new do
        extend ForInstance
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == false
        eigenclass.ancestors.include?( ModuleInstance_CascadeIncludes ).should == true
      end
      AnotherModule_ExtendB = ::Module.new do
        extend AnotherModule_ExtendA
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == false
      end
      AnotherModule_ExtendC = ::Module.new do
        extend AnotherModule_ExtendB
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == false
      end
      AnotherModule_ClassExtend = ::Class.new do
        extend AnotherModule_ExtendC
        eigenclass = class << self ; self ; end
        eigenclass.ancestors.include?( ModuleInstance_CascadeExtends ).should == false
      end

    end
  end  

  ##############################
  #  create_singleton_support  #
  #  singleton_support         #
  ##############################
  
  it 'can create a cascading support module for singleton (module/class) methods' do
    module ::CascadingConfiguration::Core::InstanceController::CreateSingletonSupportMock
    
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      
      singleton_support = InstanceController.create_singleton_support
      InstanceController.singleton_support.should == singleton_support
      
    end
  end

  #############################
  #  create_instance_support  #
  #  instance_support         #
  #############################

  it 'can create a cascading support module for instance methods' do
    module ::CascadingConfiguration::Core::InstanceController::CreateInstanceSupportMock
    
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
    
      instance_support = InstanceController.create_instance_support
      InstanceController.instance_support.should == instance_support
    
    end
  end

  ###################################
  #  create_local_instance_support  #
  #  local_instance_support         #
  ###################################

  it 'can create a non-cascading support module supporting the local object and its instances' do
    module ::CascadingConfiguration::Core::InstanceController::CreateLocalInstanceSupportMock
    
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
    
      local_instance_support = InstanceController.create_local_instance_support
      InstanceController.local_instance_support.should == local_instance_support
    
    end
  end

end