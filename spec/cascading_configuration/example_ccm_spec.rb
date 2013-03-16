# -*- encoding : utf-8 -*-

require_relative '../../lib/cascading_configuration.rb'

require_relative '../helpers/ccm.rb'
require_relative '../support/named_class_and_module.rb'

# CCM = Cascading Configuration Module
module ::CascadingConfiguration::ExampleCCM
  example_module = ::CascadingConfiguration::Module::CascadingSettings.new( :example_name, :second_name )
  ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( self, example_module )
end

describe ::CascadingConfiguration::ExampleCCM do
  
  let( :configuration_module ) { ::CascadingConfiguration::ExampleCCM }
  
  let( :configuration_name ) { :configuration_name }
  let( :configuration_write_name ) { :configuration_name= }

  let( :module_instance ) do
    _configuration_module = configuration_module
    _configuration_definer_method = configuration_definer_method
    _configuration_name = configuration_name
    _configuration_write_name = configuration_write_name
    ::Module.new.name( :ModuleInstance ).module_eval do
      include _configuration_module
      __send__( _configuration_definer_method, { _configuration_name => _configuration_write_name } )
    end
  end
    let( :module_including_module ) do
      _module_instance = module_instance
      ::Module.new.name( :ModuleIncludingModule ).module_eval { include( _module_instance ) }
    end
      let( :class_including_module_including_module ) do
        _module_including_module = module_including_module
        ::Class.new.name( :ClassIncludingModuleIncludingModule ).module_eval { include( _module_including_module ) }
      end
    let( :module_extended_by_module ) do
      ::Module.new.name( :ModuleExtendedByModule ).extend( module_instance )
    end
  let( :class_including_module ) do
    _module_instance = module_instance
    ::Class.new.name( :ClassIncludingModule ).module_eval { include( _module_instance ) }
  end
    let( :instance_of_class_including_module ) { class_including_module.new.name( :InstanceOfClassIncludingModule ) }
    let( :subclass_of_class_including_module ) do
      ::Class.new( class_including_module ).name( :SubclassOfClassIncludingModule )
    end
      let( :instance_of_subclass_of_class_including_module ) do
        subclass_of_class_including_module.new.name( :InstanceOfSubclassOfClassIncludingModule )
      end
  let( :class_extended_by_module ) do
    ::Class.new.name( :ClassExtendedByModule ).extend( module_instance )
  end
    let( :instance_of_class_extended_by_module ) do
      class_extended_by_module.new.name( :InstanceOfClassExtendedByModule )
    end
    let( :subclass_of_class_extended_by_module ) do
      ::Class.new( class_extended_by_module ).name( :SubclassOfClassExtendedByModule )
    end
      let( :instance_of_subclass_of_class_extended_by_module ) do
        subclass_of_class_extended_by_module.new.name( :InstanceOfSubclassOfClassExtendedByModule )
      end
  
  let( :class_instance ) do
    _configuration_module = configuration_module
    _configuration_definer_method = configuration_definer_method
    _configuration_name = configuration_name
    _configuration_write_name = configuration_write_name
    ::Class.new.name( :ClassInstance ).module_eval do
      include _configuration_module
      __send__( _configuration_definer_method, _configuration_name, _configuration_write_name )
    end
  end
    let( :instance_of_class ) { class_instance.new.name( :InstanceOfClass ) }
    let( :subclass ) { ::Class.new( class_instance ).name( :Subclass ) }
      let( :instance_of_subclass ) { subclass.new.name( :InstanceOfSubclass ) }
  
  let( :subclass_of_module ) do
    _configuration_module = configuration_module
    _configuration_definer_method = configuration_definer_method
    _configuration_name = configuration_name
    _configuration_write_name = configuration_write_name
    ::Class.new( ::Module ).name( :SubclassOfModule ).module_eval do
      include _configuration_module
      __send__( _configuration_definer_method, _configuration_name, _configuration_write_name )
    end
  end
  let( :instance_of_subclass_of_module ) { subclass_of_module.new.name( :InstanceOfSubclassOfModule ) }
  let( :subclass_of_subclass_of_module ) { ::Class.new( subclass_of_module ).name( :SubclassOfSubclassOfModule ) }
    let( :instance_of_subclass_of_subclass_of_module ) do
      subclass_of_subclass_of_module.new.name( :InstanceOfSubclassOfSubclassOfModule )
    end
    
  let( :cascade_args ) { [ configuration_name, configuration_write_name ] }
  
  context '========== Cascading ==========' do
    let( :configuration_definer_method ) { :attr_example_name }
    context 'module' do
      it 'will cascade singleton, instance and inheritance' do
        module_instance.should have_cascaded( nil, *cascade_args, true, true, true )
      end
      context 'module => module' do
        context 'include' do
          it 'will cascade singleton, instance and inheritance' do
            module_including_module.should have_cascaded( module_instance, *cascade_args, true, true, true )
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            module_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
        end
      end
      context 'module => class' do
        context 'include' do
          it 'will cascade singleton, instance and inheritance' do
            class_including_module.should have_cascaded( module_instance, *cascade_args, true, true, true )
          end
          context 'module => class => class (subclass)' do
            it 'will cascade singleton, instance and inheritance' do
              subclass_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, true, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will cascade singleton but not instance or inheritance' do
                instance_of_subclass_of_class_including_module.should have_cascaded( subclass_of_class_including_module, *cascade_args, true, false, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will cascade singleton but not instance or inheritance' do
              instance_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, true, false, false )
            end
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            class_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
          context 'module => class => class (subclass)' do
            it 'will not cascade singleton, instance or inheritance' do
              subclass_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, true, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_extended_by_module.should_not have_cascaded( subclass_of_class_extended_by_module, *cascade_args, true, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, true, false, false )
            end
          end
        end
      end
    end
    context 'class' do
      it 'will cascade singleton, instance and inheritance' do
        class_instance.should have_cascaded( nil, *cascade_args, true, true, true )
      end
      context 'class => class (subclass)' do
        it 'will cascade singleton, instance and inheritance' do
          subclass.should have_cascaded( class_instance, *cascade_args, true, true, true )
        end
        context 'class => class => instance (instance)' do
          it 'will cascade singleton but not instance or inheritance' do
            instance_of_subclass.should have_cascaded( subclass, *cascade_args, true, false, false )
          end
        end
      end
      context 'class => instance' do
        it 'will cascade singleton but not instance or inheritance' do
          instance_of_class.should have_cascaded( class_instance, *cascade_args, true, false, false )
        end
      end
    end
    context 'class < module' do
      it 'will cascade singleton, instance and inheritance' do
        subclass_of_module.should have_cascaded( nil, *cascade_args, true, true, true )
      end
      context 'class < module => class < module (subclass)' do
        it 'will cascade singleton, instance and inheritance' do
          subclass_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, true, true, true )
        end
        context 'class < module => class < module => instance (instance)' do
          it 'will cascade instance (to singleton) and inheritance but not singleton' do
            instance_of_subclass_of_subclass_of_module.should have_cascaded( subclass_of_subclass_of_module, *cascade_args, true, false, true )
          end
        end
      end
      context 'class < module => module (instance)' do
        it 'will cascade instance (to singleton) and inheritance but not singleton' do
          instance_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, true, false, true )
        end
      end
    end
  end

  context '========== Singleton ==========' do
    let( :configuration_definer_method ) { :attr_singleton_example_name }
    context 'module' do
      it 'will cascade singleton and inheritance but not instance' do
        module_instance.should have_cascaded( nil, *cascade_args, true, false, true )
      end
      context 'module => module' do
        context 'include' do
          it 'will cascade singleton and inheritance but not instance' do
            module_including_module.should have_cascaded( module_instance, *cascade_args, true, false, true )
          end
        end
        context 'extend' do
          it 'will not cascade singleton, instance or inheritance' do
            module_extended_by_module.should_not have_cascaded( module_instance, *cascade_args, true, false, false )
          end
        end
      end
      context 'module => class' do
        context 'include' do
          it 'will cascade singleton and inheritance but not instance' do
            class_including_module.should have_cascaded( module_instance, *cascade_args, true, false, true )
          end
          context 'module => class => class (subclass)' do
            it 'will cascade singleton and inheritance but not instance' do
              subclass_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, true, false, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_including_module.should_not have_cascaded( subclass_of_class_including_module, *cascade_args, true, false, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_including_module.should_not have_cascaded( class_including_module, *cascade_args, true, false, false )
            end
          end
        end
        context 'extend' do
          it 'will not cascade singleton, instance or inheritance' do
            class_extended_by_module.should_not have_cascaded( module_instance, *cascade_args, true, false, false )
          end
          context 'module => class => class (subclass)' do
            it 'will not cascade singleton, instance or inheritance' do
              subclass_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, true, false, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_extended_by_module.should_not have_cascaded( subclass_of_class_extended_by_module, *cascade_args, true, false, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, true, false, false )
            end
          end
        end
      end
    end
    context 'class' do
      it 'will cascade singleton and inheritance but not instance' do
        class_instance.should have_cascaded( nil, *cascade_args, true, false, true )
      end
      context 'class => class (subclass)' do
        it 'will cascade singleton and inheritance but not instance' do
          subclass.should have_cascaded( class_instance, *cascade_args, true, false, true )
        end
        context 'class => class => instance (instance)' do
          it 'will not cascade singleton, instance or inheritance' do
            instance_of_subclass.should_not have_cascaded( subclass, *cascade_args, true, false, false )
          end
        end
      end
      context 'class => instance' do
        it 'will not cascade singleton, instance or inheritance' do
          instance_of_class.should_not have_cascaded( class_instance, *cascade_args, true, false, false )
        end
      end
    end
    context 'class < module' do
      it 'will cascade singleton but not instance or inheritance' do
        subclass_of_module.should have_cascaded( nil, *cascade_args, true, false, false )
      end
      context 'class < module => class < module (subclass)' do
        it 'will cascade singleton but not instance or inheritance' do
          subclass_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, true, false, true )
        end
        context 'class < module => class < module => instance (instance)' do
          it 'will not cascade singleton, instance or inheritance' do
            instance_of_subclass_of_subclass_of_module.should_not have_cascaded( subclass_of_subclass_of_module, *cascade_args, true, false, false )
          end
        end
      end
      context 'class < module => module (instance)' do
        it 'will not cascade singleton, instance or inheritance' do
          instance_of_subclass_of_module.should_not have_cascaded( subclass_of_module, *cascade_args, true, false, false )
        end
      end
    end
  end

  context '========== Instance ==========' do
    let( :configuration_definer_method ) { :attr_instance_example_name }
    context 'module' do
      it 'will cascade instance and inheritance but not singleton' do
        module_instance.should have_cascaded( nil, *cascade_args, false, true, true )
      end
      context 'module => module' do
        context 'include' do
          it 'will cascade instance and inheritance but not singleton' do
            module_including_module.should have_cascaded( module_instance, *cascade_args, false, true, true )
          end
        end
        context 'extend' do
          it 'will not cascade singleton, instance or inheritance' do
            module_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
        end
      end
      context 'module => class' do
        context 'include' do
          it 'will cascade instance and inheritance but not singleton' do
            class_including_module.should have_cascaded( module_instance, *cascade_args, false, true, true )
          end
          context 'module => class => class (subclass)' do
            it 'will cascade instance and inheritance but not singleton' do
              subclass_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, false, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will cascade instance but not singleton or inheritance' do
                instance_of_subclass_of_class_including_module.should have_cascaded( subclass_of_class_including_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will cascade instance but not singleton or inheritance' do
              instance_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, false, true, false )
            end
          end
        end
        context 'extend' do
          it 'will not cascade singleton, instance or inheritance' do
            class_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
          context 'module => class => class (subclass)' do
            it 'will not cascade singleton, instance or inheritance' do
              subclass_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, false, true, false )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_extended_by_module.should_not have_cascaded( subclass_of_class_extended_by_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, false, true, false )
            end
          end
        end
      end
    end
    context 'class' do
      it 'will cascade instance and inheritance but not singleton' do
        class_instance.should have_cascaded( nil, *cascade_args, false, true, true )
      end
      context 'class => class (subclass)' do
        it 'will cascade instance and inheritance but not singleton' do
          subclass.should have_cascaded( class_instance, *cascade_args, false, true, true )
        end
        context 'class => class => instance (instance)' do
          it 'will cascade instance but not singleton or inheritance' do
            instance_of_subclass.should have_cascaded( subclass, *cascade_args, false, true, false )
          end
        end
      end
      context 'class => instance' do
        it 'will cascade instance but not singleton or inheritance' do
          instance_of_class.should have_cascaded( class_instance, *cascade_args, false, true, false )
        end
      end
    end
    context 'class < module' do
      it 'will not cascade singleton, instance or inheritance' do
        subclass_of_module.should_not have_cascaded( nil, *cascade_args, true, false, true )
      end
      context 'class < module => class < module (subclass)' do
        it 'will cascade instance and inheritance but not singleton' do
          subclass_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, false, true, true )
        end
        context 'class < module => class < module => instance (instance)' do
          it 'will cascade singleton but not instance or inheritance' do
            instance_of_subclass_of_subclass_of_module.should have_cascaded( subclass_of_subclass_of_module, *cascade_args, true, false, true )
          end
        end
      end
      context 'class < module => module (instance)' do
        it 'will cascade singleton but not instance or inheritance' do
          instance_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, true, false, true )
        end
      end
    end
  end

  context '========== Object ==========' do
    let( :configuration_definer_method ) { :attr_object_example_name }
    context 'module' do
      it 'will cascade singleton, instance and inheritance' do
        module_instance.should have_cascaded( nil, *cascade_args, true, true, true )
      end
      context 'module => module' do
        context 'include' do
          it 'will cascade instance and inheritance but not singleton' do
            module_including_module.should have_cascaded( module_instance, *cascade_args, false, true, true )
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            module_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
        end
      end
      context 'module => class' do
        context 'include' do
          it 'will cascade instance and inheritance but not singleton' do
            class_including_module.should have_cascaded( module_instance, *cascade_args, false, true, true )
          end
          context 'module => class => class (subclass)' do
            it 'will cascade instance and inheritance but not singleton' do
              subclass_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, false, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will cascade singleton but not instance or inheritance' do
                instance_of_subclass_of_class_including_module.should have_cascaded( subclass_of_class_including_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will cascade singleton but not instance or inheritance' do
              instance_of_class_including_module.should have_cascaded( class_including_module, *cascade_args, false, true, false )
            end
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            class_extended_by_module.should have_cascaded( module_instance, *cascade_args, true, false, false )
          end
          context 'module => class => class (subclass)' do
            it 'will not cascade singleton, instance or inheritance' do
              subclass_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, false, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_extended_by_module.should_not have_cascaded( subclass_of_class_extended_by_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, false, true, false )
            end
          end
        end
      end
    end
    context 'class' do
      it 'will cascade instance and inheritance but not singleton' do
        class_instance.should have_cascaded( nil, *cascade_args, false, true, true )
      end
      context 'class => class (subclass)' do
        it 'will cascade instance and inheritance but not singleton' do
          subclass.should have_cascaded( class_instance, *cascade_args, false, true, true )
        end
        context 'class => class => instance (instance)' do
          it 'will cascade singleton but not instance or inheritance' do
            instance_of_subclass.should have_cascaded( subclass, *cascade_args, false, true, false )
          end
        end
      end
      context 'class => instance' do
        it 'will cascade singleton but not instance or inheritance' do
          instance_of_class.should have_cascaded( class_instance, *cascade_args, false, true, false )
        end
      end
    end
    context 'class < module' do
      it 'will cascade instance and inheritance but not singleton' do
        subclass_of_module.should have_cascaded( nil, *cascade_args, false, true, true )
      end
      context 'class < module => class < module (subclass)' do
        it 'will cascade instance and inheritance but not singleton' do
          subclass_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, false, true, true )
        end
        context 'class < module => class < module => instance (instance)' do
          it 'will cascade instance (to singleton) and inheritance but not singleton' do
            instance_of_subclass_of_subclass_of_module.should have_cascaded( subclass_of_subclass_of_module, *cascade_args, true, false, true )
          end
        end
      end
      context 'class < module => module (instance)' do
        it 'will cascade instance (to singleton) and inheritance but not singleton' do
          instance_of_subclass_of_module.should have_cascaded( subclass_of_module, *cascade_args, true, false, true )
        end
      end
    end
  end

  context '========== Local Instance ==========' do
    let( :configuration_definer_method ) { :attr_local_instance_example_name }
    context 'module' do
      it 'will cascade singleton, instance and inheritance' do
        module_instance.should have_cascaded( nil, *cascade_args, true, false, false )
      end
      context 'module => module' do
        context 'include' do
          it 'will cascade singleton, instance and inheritance' do
            module_including_module.should_not have_cascaded( module_instance, *cascade_args, false, true, true )
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            module_extended_by_module.should_not have_cascaded( module_instance, *cascade_args, true, false, false )
          end
        end
      end
      context 'module => class' do
        context 'include' do
          it 'will cascade singleton, instance and inheritance' do
            class_including_module.should_not have_cascaded( module_instance, *cascade_args, false, true, true )
          end
          context 'module => class => class (subclass)' do
            it 'will cascade singleton, instance and inheritance' do
              subclass_of_class_including_module.should_not have_cascaded( class_including_module, *cascade_args, false, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will cascade singleton but not instance or inheritance' do
                instance_of_subclass_of_class_including_module.should_not have_cascaded( subclass_of_class_including_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will cascade singleton but not instance or inheritance' do
              instance_of_class_including_module.should_not have_cascaded( class_including_module, *cascade_args, true, false, false )
            end
          end
        end
        context 'extend' do
          it 'will cascade singleton but not instance or inheritance' do
            class_extended_by_module.should_not have_cascaded( module_instance, *cascade_args, true, false, false )
          end
          context 'module => class => class (subclass)' do
            it 'will not cascade singleton, instance or inheritance' do
              subclass_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, true, true, true )
            end
            context 'module => class => class => instance (instance)' do
              it 'will not cascade singleton, instance or inheritance' do
                instance_of_subclass_of_class_extended_by_module.should_not have_cascaded( subclass_of_class_extended_by_module, *cascade_args, false, true, false )
              end
            end
          end
          context 'module => class => instance' do
            it 'will not cascade singleton, instance or inheritance' do
              instance_of_class_extended_by_module.should_not have_cascaded( class_extended_by_module, *cascade_args, false, true, false )
            end
          end
        end
      end
    end
    context 'class' do
      it 'will cascade singleton, instance and inheritance' do
        class_instance.should_not have_cascaded( nil, *cascade_args, true, true, true )
      end
      context 'class => class (subclass)' do
        it 'will cascade singleton, instance and inheritance' do
          subclass.should_not have_cascaded( class_instance, *cascade_args, true, true, true )
        end
        context 'class => class => instance (instance)' do
          it 'will cascade singleton but not instance or inheritance' do
            instance_of_subclass.should_not have_cascaded( subclass, *cascade_args, false, true, false )
          end
        end
      end
      context 'class => instance' do
        it 'will cascade singleton but not instance or inheritance' do
          instance_of_class.should_not have_cascaded( class_instance, *cascade_args, false, true, false )
        end
      end
    end
    context 'class < module' do
      it 'will cascade singleton, instance and inheritance' do
        subclass_of_module.should_not have_cascaded( nil, *cascade_args, false, true, true )
      end
      context 'class < module => class < module (subclass)' do
        it 'will cascade singleton, instance and inheritance' do
          subclass_of_subclass_of_module.should_not have_cascaded( subclass_of_module, *cascade_args, false, true, true )
        end
        context 'class < module => class < module => instance (instance)' do
          it 'will cascade instance (to singleton) and inheritance but not singleton' do
            instance_of_subclass_of_subclass_of_module.should_not have_cascaded( subclass_of_subclass_of_module, *cascade_args, false, true, false )
          end
        end
      end
      context 'class < module => module (instance)' do
        it 'will cascade instance (to singleton) and inheritance but not singleton' do
          instance_of_subclass_of_module.should_not have_cascaded( subclass_of_module, *cascade_args, false, true, false )
        end
      end
    end
  end

end
