
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController::SupportModule do

  before :all do
    @instance = ::Module.new
    @instance_controller = ::CascadingConfiguration::Core::InstanceController.new( @instance_controller )
    @module_instance = ::CascadingConfiguration::Core::InstanceController::SupportModule.new( @instance_controller, :some_type )
    @ccm = ::Module.new
  end

  ################
  #  initialize  #
  ################
  
  it 'can create a module for use with an instance for dynamic definition' do
    @instance.ancestors.include?( @module_instance ).should == false
    @instance.is_a?( @module_instance ).should == false
  end

  ###################
  #  super_modules  #
  ###################
  
  it 'can return the first super module on each parent tree' do

    instance_A = ::Module.new
    instance_controller_A = ::CascadingConfiguration::Core::InstanceController.new( instance_A )
    module_A = instance_controller_A.create_support( :some_type )

    instance_B1 = ::Module.new
    ::CascadingConfiguration.register_parent( instance_B1, instance_A )

    instance_B2 = ::Module.new
    ::CascadingConfiguration.register_parent( instance_B2, instance_A )

    instance_C1 = ::Module.new
    ::CascadingConfiguration.register_parent( instance_C1, instance_B1 )

    instance_C2 = ::Module.new
    ::CascadingConfiguration.register_parent( instance_C2, instance_B1 )

    instance_D = ::Module.new
    ::CascadingConfiguration.register_parent( instance_D, instance_B2 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C1 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C2 )

    module_A.super_modules.empty?.should == true

    instance_controller_B2 = ::CascadingConfiguration::Core::InstanceController.new( instance_B2 )
    module_B2 = instance_controller_B2.create_support( :some_type )
    module_B2.super_modules.should == [ module_A ]

    instance_controller_C1 = ::CascadingConfiguration::Core::InstanceController.new( instance_C1 )
    module_C1 = instance_controller_C1.create_support( :some_type )
    module_B2.super_modules.should == [ module_A ]
    module_C1.super_modules.should == [ module_A ]

    instance_controller_C2 = ::CascadingConfiguration::Core::InstanceController.new( instance_C2 )
    module_C2 = instance_controller_C2.create_support( :some_type )
    module_B2.super_modules.should == [ module_A ]
    module_C1.super_modules.should == [ module_A ]
    module_C2.super_modules.should == [ module_A ]

    instance_controller_B1 = ::CascadingConfiguration::Core::InstanceController.new( instance_B1 )
    module_B1 = instance_controller_B1.create_support( :some_type )
    module_B1.super_modules.should == [ module_A ]
    module_B2.super_modules.should == [ module_A ]
    module_C1.super_modules.should == [ module_B1 ]
    module_C2.super_modules.should == [ module_B1 ]

    instance_controller_D = ::CascadingConfiguration::Core::InstanceController.new( instance_D )
    module_D = instance_controller_D.create_support( :some_type )
    module_B1.super_modules.should == [ module_A ]
    module_B2.super_modules.should == [ module_A ]
    module_C1.super_modules.should == [ module_B1 ]
    module_C2.super_modules.should == [ module_B1 ]
    module_D.super_modules.should == [ module_C2, module_C1, module_B2 ]

  end
  
  ###################
  #  child_modules  #
  ###################
  
  it 'can return the first child module on each child tree' do
    # set up hierarchy
    instance_A = ::Module.new do
      # we have to mock the method bc that's how the module determines if it has a configuration defined
      # since we don't know whether a configuration value has been set yet
      attr_accessor :some_configuration
    end
    instance_controller_A = ::CascadingConfiguration::Core::InstanceController.new( instance_A )
    module_A = instance_controller_A.create_support( :some_type )
    instance_B1 = ::Module.new do
      # we have to mock the method bc that's how the module determines if it has a configuration defined
      # since we don't know whether a configuration value has been set yet
      attr_accessor :some_other_configuration
      include instance_A
    end
    ::CascadingConfiguration.register_parent( instance_B1, instance_A )
    instance_B2 = ::Module.new do
      include instance_A
    end
    ::CascadingConfiguration.register_parent( instance_B2, instance_A )
    instance_C1 = ::Module.new do
      include instance_B1
      attr_accessor :yet_another_configuration
    end
    ::CascadingConfiguration.register_parent( instance_C1, instance_B1 )
    instance_C2 = ::Module.new do
      include instance_B1
    end
    ::CascadingConfiguration.register_parent( instance_C2, instance_B1 )
    instance_D = ::Module.new do
      include instance_B2
      include instance_C1
      include instance_C2
    end
    ::CascadingConfiguration.register_parent( instance_D, instance_B2 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C1 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C2 )
    instance_controller_B2 = ::CascadingConfiguration::Core::InstanceController.new( instance_B2 )
    module_B2 = instance_controller_B2.create_support( :some_type )
    instance_controller_C1 = ::CascadingConfiguration::Core::InstanceController.new( instance_C1 )
    module_C1 = instance_controller_C1.create_support( :some_type )
    instance_controller_C2 = ::CascadingConfiguration::Core::InstanceController.new( instance_C2 )
    module_C2 = instance_controller_C2.create_support( :some_type )
    instance_controller_B1 = ::CascadingConfiguration::Core::InstanceController.new( instance_B1 )
    module_B1 = instance_controller_B1.create_support( :some_type )
    instance_controller_D = ::CascadingConfiguration::Core::InstanceController.new( instance_D )
    module_D = instance_controller_D.create_support( :some_type )
    module_A.child_modules.should == [ module_B1, module_B2 ]
    module_B1.child_modules.should == [ module_C1, module_C2 ]
    module_B2.child_modules.should == [ module_D ]
    module_C1.child_modules.should == [ module_D ]
    module_C2.child_modules.should == [ module_D ]
    module_D.child_modules.empty?.should == true
  end
  
  ###########################################
  #  cascade_new_support_for_child_modules  #
  ###########################################
  
  it 'can return the first child module on each child tree' do
    # set up hierarchy
    instance_A = ::Module.new
    instance_controller_A = ::CascadingConfiguration::Core::InstanceController.new( instance_A )
    module_A = instance_controller_A.create_support( :some_type )
    instance_B1 = ::Module.new
    ::CascadingConfiguration.register_parent( instance_B1, instance_A )
    instance_B2 = ::Module.new do
      include instance_A
    end
    ::CascadingConfiguration.register_parent( instance_B2, instance_A )
    instance_C1 = ::Module.new do
      include instance_B1
      attr_accessor :yet_another_configuration
    end
    ::CascadingConfiguration.register_parent( instance_C1, instance_B1 )
    instance_C2 = ::Module.new do
      include instance_B1
    end
    ::CascadingConfiguration.register_parent( instance_C2, instance_B1 )
    instance_D = ::Module.new do
      include instance_B2
      include instance_C1
      include instance_C2
    end
    ::CascadingConfiguration.register_parent( instance_D, instance_B2 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C1 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C2 )
    module_A.child_modules.empty?.should == true
    instance_controller_C2 = ::CascadingConfiguration::Core::InstanceController.new( instance_C2 )
    module_C2 = instance_controller_C2.create_support( :some_type )
    module_A.child_modules.should == [ module_C2 ]
    module_C2.child_modules.empty?.should == true
    instance_controller_B2 = ::CascadingConfiguration::Core::InstanceController.new( instance_B2 )
    module_B2 = instance_controller_B2.create_support( :some_type )
    module_A.child_modules.should == [ module_C2, module_B2 ]
    module_B2.child_modules.empty?.should == true
    module_C2.child_modules.empty?.should == true
    instance_controller_C1 = ::CascadingConfiguration::Core::InstanceController.new( instance_C1 )
    module_C1 = instance_controller_C1.create_support( :some_type )
    module_A.child_modules.should == [ module_C1, module_C2, module_B2 ]
    module_B2.child_modules.empty?.should == true
    module_C1.child_modules.empty?.should == true
    module_C2.child_modules.empty?.should == true
    instance_controller_D = ::CascadingConfiguration::Core::InstanceController.new( instance_D )
    module_D = instance_controller_D.create_support( :some_type )
    module_A.child_modules.should == [ module_C1, module_C2, module_B2 ]
    module_B2.child_modules.should == [ module_D ]
    module_C1.child_modules.should == [ module_D ]
    module_C2.child_modules.should == [ module_D ]
    module_D.child_modules.empty?.should == true
    instance_controller_B1 = ::CascadingConfiguration::Core::InstanceController.new( instance_B1 )
    module_B1 = instance_controller_B1.create_support( :some_type )
    module_A.child_modules.should == [ module_B1, module_B2 ]
    module_B1.child_modules.should == [ module_C1, module_C2 ]
    module_B2.child_modules.should == [ module_D ]
    module_C1.child_modules.should == [ module_D ]
    module_C2.child_modules.should == [ module_D ]
    module_D.child_modules.empty?.should == true
  end
  
  ###################
  #  define_method  #
  #  alias_method   #
  #  remove_method  #
  #  undef_method   #
  ###################
  
  it 'can define a method in the configuration module, ensuring the module exists first' do
    module_instance = @instance_controller.create_support( :some_type )
    module_instance.define_method( :some_method ) do
      return :some_method
    end
    module_instance.method_defined?( :some_method ).should == true
    module_instance.alias_method( :some_alias, :some_method )
    module_instance.method_defined?( :some_method ).should == true
    module_instance.method_defined?( :some_alias ).should == true
    module_instance.remove_method( :some_alias ).should == true
    module_instance.method_defined?( :some_alias ).should == false
    module_instance.remove_method( :some_alias ).should == false
    module_instance.undef_method( :some_method ).should == true
    module_instance.method_defined?( :some_method ).should == false
    module_instance.undef_method( :some_method ).should == false
  end

end
