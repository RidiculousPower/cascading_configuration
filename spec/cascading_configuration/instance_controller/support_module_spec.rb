# -*- encoding : utf-8 -*-

require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::InstanceController::SupportModule do

  let( :instance_A ) do
    ::Module.new.name( :InstanceA )
  end
  let( :instance_B1 ) do
    instance_B1 = ::Module.new.name( :instance_B1 )
    ::CascadingConfiguration.register_parent( instance_B1, instance_A )
    instance_B1
  end
  let( :instance_B2 ) do 
    instance_B2 = ::Module.new.name( :instance_B2 )
    ::CascadingConfiguration.register_parent( instance_B2, instance_A )
    instance_B2
  end
  let( :instance_C1 ) do
    instance_C1 = ::Module.new.name( :instance_C1 )
    ::CascadingConfiguration.register_parent( instance_C1, instance_B1 )
    instance_C1
  end
  let( :instance_C2 ) do
    instance_C2 = ::Module.new.name( :instance_C2 )
    ::CascadingConfiguration.register_parent( instance_C2, instance_B1 )
    instance_C2
  end
  let( :instance_D ) do
    instance_D = ::Module.new.name( :instance_D )
    ::CascadingConfiguration.register_parent( instance_D, instance_B2 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C1 )
    ::CascadingConfiguration.register_parent( instance_D, instance_C2 )
    instance_D
  end
  let( :instance_controller_A ) { ::CascadingConfiguration::InstanceController.new( instance_A ) }
  let( :instance_controller_B1 ) { ::CascadingConfiguration::InstanceController.new( instance_B1 ) }
  let( :instance_controller_B2 ) { ::CascadingConfiguration::InstanceController.new( instance_B2 ) }
  let( :instance_controller_C1 ) { ::CascadingConfiguration::InstanceController.new( instance_C1 ) }
  let( :instance_controller_C2 ) { ::CascadingConfiguration::InstanceController.new( instance_C2 ) }
  let( :instance_controller_D ) { ::CascadingConfiguration::InstanceController.new( instance_D ) }
  let( :module_A ) { instance_controller_A.instance_eval { create_support( :some_type ) } }
  let( :module_B1 ) { instance_controller_B1.instance_eval { create_support( :some_type ) } }
  let( :module_B2 ) { instance_controller_B2.instance_eval { create_support( :some_type ) } }
  let( :module_C1 ) { instance_controller_C1.instance_eval { create_support( :some_type ) } }
  let( :module_C2 ) { instance_controller_C2.instance_eval { create_support( :some_type ) } }
  let( :module_D ) { instance_controller_D.instance_eval { create_support( :some_type ) } }
  let( :create_module_A ) { module_A }
  let( :create_module_B1 ) { module_B1 }
  let( :create_module_B2 ) { module_B2 }
  let( :create_module_C1 ) { module_C1 }
  let( :create_module_C2 ) { module_C2 }
  let( :create_module_D ) { module_D }

  ###################
  #  super_modules  #
  ###################
  
  context '#super_modules' do
    
    context 'when no super modules' do
      before :each do
        create_module_A
      end
      it 'will not have super modules' do
        module_A.super_modules.empty?.should == true
      end
    end
    context 'when one immediate super module' do
      before :each do
        create_module_A
        create_module_B2
      end
      it 'will return the super module' do
        module_B2.super_modules.should == [ module_A ]
      end
    end
    context 'when one non-immediate super module' do
      before :each do
        create_module_A
        create_module_B2
        create_module_C1
        create_module_C2
      end
      it 'will return the super module' do
        module_B2.super_modules.should == [ module_A ]
        module_C1.super_modules.should == [ module_A ]
        module_C2.super_modules.should == [ module_A ]
      end
    end
    context 'when a tree with multiple super modules' do
      before :each do
        # order of creation should not matter
        create_module_A
        create_module_C1
        create_module_B1
        create_module_D
        create_module_C2
        create_module_B2
      end
      it 'will return the super modules for each branch' do
        module_B1.super_modules.should == [ module_A ]
        module_B2.super_modules.should == [ module_A ]
        module_C1.super_modules.should == [ module_B1 ]
        module_C2.super_modules.should == [ module_B1 ]
        module_D.super_modules.should == [ module_C2, module_C1, module_B2 ]
      end
    end
  end
  
  ###################
  #  child_modules  #
  ###################
  
  context '#child_modules' do

    before :each do
      # order of creation should not matter
      create_module_A
      create_module_C1
      create_module_B1
      create_module_D
      create_module_C2
      create_module_B2
    end

    it 'can return the first child module on each child tree' do
      module_A.child_modules.should == [ module_B1, module_B2 ]
      module_B1.child_modules.should == [ module_C1, module_C2 ]
      module_B2.child_modules.should == [ module_D ]
      module_C1.child_modules.should == [ module_D ]
      module_C2.child_modules.should == [ module_D ]
      module_D.child_modules.empty?.should == true
    end
    
  end

  ###################
  #  define_method  #
  #  alias_method   #
  #  remove_method  #
  #  undef_method   #
  ###################

  let( :instance ) { ::Module.new }
  let( :instance_controller ) { ::CascadingConfiguration::InstanceController.new( instance ) }
  let( :ccm ) { ::Module.new }
  let( :module_instance ) do
    ::CascadingConfiguration::InstanceController::SupportModule.new( instance_controller, :some_type, nil )
  end
  
  it 'can define a method in the configuration module, ensuring the module exists first' do
    module_instance = instance_controller.instance_eval { create_support( :some_type ) }
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
