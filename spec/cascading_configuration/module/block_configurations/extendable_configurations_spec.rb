# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

require_relative '../../module_setup.rb'
require_relative '../../module_shared_examples.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations do
  
  setup_module_tests
  
  let( :extendable_configurations_ccm ) do
    ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations.new( ccm_name, *ccm_aliases )
  end
  
  it_behaves_like :configuration_module do
    let( :instance ) { extendable_configurations_ccm }
  end

  let( :configuration_instance ) { ::Module.new.name( :Instance ) }
  
  ###########################
  #  define_configurations  #
  ###########################
  
  context '#define_configurations' do

    # mockup using example from perspective-bindings

    let( :singleton_module ) { ::Module.new.name( :SingletonModule ) }
    let( :instance_module ) { ::Module.new.name( :InstanceModule ) }
    let( :class_binding_module ) { ::Module.new.name( :ClassBindingModule ) }
    let( :instance_binding_module ) { ::Module.new.name( :InstanceBindingModule ) }

    let( :singleton_extension_proc ) { ::Proc.new { :singleton_value } }
    let( :instance_extension_proc ) { ::Proc.new { :instance_value } }
    let( :class_binding_extension_proc ) { ::Proc.new { :class_binding_value } }
    let( :instance_binding_extension_proc ) { ::Proc.new { :instance_binding_value } }

    let( :singleton_module_configuration ) do
      extendable_configurations_ccm.define_configurations( singleton_module, :instance, :configuration_name, & singleton_extension_proc )
      ::CascadingConfiguration.configuration( singleton_module, :configuration_name )
    end
    let( :instance_module_configuration ) do
      extendable_configurations_ccm.define_configurations( instance_module, :instance, :configuration_name, & instance_extension_proc )
      ::CascadingConfiguration.configuration( instance_module, :configuration_name )
    end
    let( :class_binding_module_configuration ) do
      extendable_configurations_ccm.define_configurations( class_binding_module, :instance, :configuration_name, & class_binding_extension_proc )
      ::CascadingConfiguration.configuration( class_binding_module, :configuration_name )
    end
    let( :instance_binding_module_configuration ) do
      extendable_configurations_ccm.define_configurations( instance_binding_module, :instance, :configuration_name, & instance_binding_extension_proc )
      ::CascadingConfiguration.configuration( instance_binding_module, :configuration_name )
    end

    let( :singleton_instance ) do
      singleton_instance = ::Class.new.name( :SingletonInstance )
      _singleton_module = singleton_module
#      singleton_instance.instance_eval { include _singleton_module }
      ::CascadingConfiguration.register_parent( singleton_instance, singleton_module, :extend )
      ::CascadingConfiguration.register_parent( singleton_instance, instance_module, :include )
      singleton_instance
    end
    let( :local_instance ) do
      object_instance = singleton_instance.new.name( :ObjectInstance )
      ::CascadingConfiguration.register_parent( object_instance, singleton_instance, :instance )
      object_instance
    end
    let( :class_binding_class ) do
      class_binding_class = ::Class.new.name( :ClassBindingClass )
      _instance_module = instance_module
#      class_binding_class.instance_eval { include _instance_module }
      ::CascadingConfiguration.register_parent( class_binding_class, class_binding_module, :include )
      class_binding_class
    end
    let( :class_binding_instance ) do
      class_binding_instance = class_binding_class.new.name( :ClassBindingInstance )
      ::CascadingConfiguration.register_parent( class_binding_instance, class_binding_class, :instance )
      class_binding_instance
    end
    let( :instance_binding_class ) do
      instance_binding_class = ::Class.new.name( :InstanceBindingClass )
      _class_binding_module = class_binding_module
#      instance_binding_class.instance_eval { include _class_binding_module }
      ::CascadingConfiguration.register_parent( instance_binding_class, instance_binding_module, :include )
      instance_binding_class
    end
    let( :instance_binding_instance ) do
      instance_binding_instance = instance_binding_class.new.name( :InstanceBindingInstance )
      ::CascadingConfiguration.register_parent( instance_binding_instance, instance_binding_class, :instance )
      instance_binding_instance
    end

    let( :singleton_instance_configuration ) do
      ::CascadingConfiguration.configuration( singleton_instance, :configuration_name )
    end
    let( :local_instance_configuration ) do
      ::CascadingConfiguration.configuration( object_instance, :configuration_name )
    end
    let( :class_binding_instance_configuration ) do
      ::CascadingConfiguration.configuration( class_binding_instance, :configuration_name )
    end
    let( :instance_binding_instance_configuration ) do
      ::CascadingConfiguration.configuration( instance_binding_instance, :configuration_name )
    end
    
    before :each do
      singleton_module_configuration
      instance_module_configuration
      class_binding_module_configuration
      instance_binding_module_configuration
    end
    
    #it 'should isolate extension modules by the ruby inheritance hierarchy' do
    #  singleton_instance_configuration.extension_modules.should == singleton_module_configuration.extension_modules
    #  local_instance_configuration.extension_modules.should == instance_module_configuration.extension_modules
    #  class_binding_instance_configuration.extension_modules.should == class_binding_module_configuration.extension_modules
    #  instance_binding_instance_configuration.extension_modules.should == instance_binding_module_configuration.extension_modules
    #end
  end
    
end
