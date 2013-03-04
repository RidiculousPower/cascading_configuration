# -*- encoding : utf-8 -*-

require_relative '../../lib/cascading_configuration.rb'

require_relative '../helpers/support_module.rb'

require_relative '../support/named_class_and_module.rb'

describe ::CascadingConfiguration::InstanceController do

  let( :instance ) { ::Module.new.name( :Instance ) }
  let( :instance_controller ) { ::CascadingConfiguration::InstanceController.new( instance ) }

  ##################################################################################################
  #   private ######################################################################################
  ##################################################################################################
  
  ####################
  #  create_support  #
  ####################
  
  context '#create_support' do

    let( :module_type_name ) { :arbitrary_type_name }
    let( :support_module_class ) { ::CascadingConfiguration::InstanceController::SupportModule }
    let( :module_constant_name ) { module_type_name.to_s.to_camel_case }
    
    let( :support_module ) do
      _module_type_name = module_type_name
      _module_inheritance_model = module_inheritance_model
      _support_module_class = support_module_class
      _module_constant_name = module_constant_name
      instance_controller.instance_eval { create_support( _module_type_name, 
                                                          _module_inheritance_model, 
                                                          _support_module_class, 
                                                          _module_constant_name ) }
    end
    
    let( :create_support_args ) { [ support_module, 
                                    module_type_name, 
                                    module_inheritance_model, 
                                    support_module_class, 
                                    module_constant_name ] }
    
    before :each do
      support_module
    end
    
    context 'for any use context' do
      let( :module_constant_name ) { :SomeConstantName }
      let( :module_inheritance_model ) { nil }
      context 'when nil is specified for support module class' do
        let( :support_module_class ) { nil }
        it 'will use default module class' do
          support_module.should be_a( ::CascadingConfiguration::InstanceController::SupportModule )
        end
      end
      context 'when a support module class is specified' do
        let( :support_module_class ) { ::CascadingConfiguration::InstanceController::SupportModule::SingletonSupportModule }
        it 'will use the class to create the support module instance' do
          support_module.should be_a( support_module_class )
        end
      end
      context 'when a constant name is not specified' do
        it 'will use the module type name in camel case' do
          instance_controller.const_get( module_constant_name ).should == support_module
        end
      end
      context 'when a constant name is specified' do
        let( :module_constant_name ) { 'SomeRandomConstantName' }
        it 'will be used as the support module constant name' do
          instance_controller.const_get( module_constant_name ).should == support_module
        end
      end
    end

    context 'module_inheritance_model: singleton' do
      
      let( :module_inheritance_model ) { :singleton }

      context 'module instance' do
        let( :including_module ) do
          _module_instance = instance
          ::Module.new { include( _module_instance ) }
        end
        let( :class_including_module ) do
          _module_instance = instance
          ::Class.new { include( _module_instance ) }
        end
        let( :subclass_of_class_including_module ) { ::Class.new( class_including_module ) }
        let( :nth_subclass_of_class_including_module ) { ::Class.new( subclass_of_class_including_module ) }
        let( :nth_module_including_including_module ) do
          _including_module = including_module
          ::Module.new { include( _including_module ) }
        end
        let( :nth_module_extended_by_including_module ) { ::Module.new.extend( including_module ) }
        let( :n_plus_one_module_extended_by_including_module ) do
          ::Module.new.extend( nth_module_including_including_module )
        end
        let( :class_including_nth_including_module ) do
          _nth_module_including_including_module = nth_module_including_including_module
          ::Class.new { include( _nth_module_including_including_module ) }
        end
        let( :subclass_of_class_including_nth_including_module ) { ::Class.new( class_including_nth_including_module ) }
        let( :nth_subclass_of_class_including_nth_including_module ) do
          ::Class.new( subclass_of_class_including_nth_including_module )
        end
        let( :class_extended_by_nth_including_module ) { ::Class.new.extend( nth_module_including_including_module ) }
        let( :subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( class_extended_by_nth_including_module )
        end
        let( :nth_subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( subclass_of_class_extended_by_nth_including_module )
        end
        it 'will create a cascading singleton support module for a module instance' do
          instance_controller.should have_created_support( *create_support_args )
        end
        context 'module including module with singleton support' do

          it 'the support module will cascade to an including module' do
            including_module.should have_been_extended_by( support_module )
            including_module.should_not have_included( support_module )
          end

          it 'the support module will cascade to an including class' do
            class_including_module.should have_been_extended_by( support_module )
            class_including_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an including class' do
            subclass_of_class_including_module.should have_been_extended_by( support_module )
            subclass_of_class_including_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to any nth subclass of an including class' do
            nth_subclass_of_class_including_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_including_module.should_not have_included( support_module )
          end

          it 'an including module will cascade to an nth including module' do
            nth_module_including_including_module.should have_been_extended_by( support_module )
            nth_module_including_including_module.should_not have_included( support_module )
          end

          it 'an including module will not cascade the support module to an nth extending module' do
            nth_module_extended_by_including_module.should_not have_been_extended_by( support_module )
            nth_module_extended_by_including_module.should_not have_included( support_module )
          end
          it 'an nth extending module will not cascade the support module to an n + 1 extending module' do
            n_plus_one_module_extended_by_including_module.should_not have_been_extended_by( support_module )
            n_plus_one_module_extended_by_including_module.should_not have_included( support_module )
          end

          it 'an nth including module will cascade the support module to an including class' do
            class_including_nth_including_module.should have_been_extended_by( support_module )
            class_including_nth_including_module.should_not have_included( support_module )
          end
          it 'a class including nth module will cascade the support module to a subclass' do
            subclass_of_class_including_nth_including_module.should have_been_extended_by( support_module )
            subclass_of_class_including_nth_including_module.should_not have_included( support_module )
          end
          it 'an nth subclass of class including nth module will cascade the support module to an n + 1 subclass' do
            nth_subclass_of_class_including_nth_including_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_including_nth_including_module.should_not have_included( support_module )
          end

          it 'an nth including module will cascade the support module to an extending class' do
            class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'a class extended by nth module will cascade the support module to a subclass due to the Ruby inheritance model' do
            subclass_of_class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'any nth subclass of class extended by nth module will cascade the support module due to the Ruby inheritance model' do
            nth_subclass_of_class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          
        end
        context 'module extended by module with singleton support' do

          let( :extending_module ) { ::Module.new.extend( instance ) }
          let( :module_including_extended_module ) do
            _extending_module = extending_module
            ::Module.new { include( _extending_module ) }
          end
          let( :module_extended_by_extending_module ) { ::Module.new.extend( extending_module ) }
          
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) { ::Class.new( subclass_of_class_extended_by_extended_module ) }
          
          it 'the support module will not cascade to an extending module' do
            extending_module.should_not have_been_extended_by( support_module )
            extending_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an including module' do
            module_including_extended_module.should_not have_been_extended_by( support_module )
            module_including_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an extending module' do
            module_extended_by_extending_module.should_not have_been_extended_by( support_module )
            module_extended_by_extending_module.should_not have_included( support_module )
          end

          it 'the support module will notcascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          
        end
        context 'class including module with singleton support' do
          let( :class_extended_by_extended_module ) do
            _module_instance = instance
            ::Class.new { include( _module_instance ) }
          end
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will cascade to an extending class' do
            class_extended_by_extended_module.should have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end

        end
        context 'class extended by module with singleton support' do
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will not cascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
        end       
      end
      context 'class instance' do
        let( :instance ) { ::Class.new }
        let( :subclass ) { ::Class.new( instance ) }
        let( :nth_subclass ) { ::Class.new( subclass ) }
        it 'the support module will cascade to a subclass of an extended class' do
          subclass.should have_been_extended_by( support_module )
          subclass.should_not have_included( support_module )
        end
        it 'the support module will cascade to an nth subclass of an extended class' do
          nth_subclass.should have_been_extended_by( support_module )
          nth_subclass.should_not have_included( support_module )
        end
      end

    end

    context 'module_inheritance_model: instance' do

      let( :module_inheritance_model ) { :instance }

      context 'module instance' do
        let( :including_module ) do
          _module_instance = instance
          ::Module.new { include( _module_instance ) }
        end
        let( :class_including_module ) do
          _module_instance = instance
          ::Class.new { include( _module_instance ) }
        end
        let( :subclass_of_class_including_module ) { ::Class.new( class_including_module ) }
        let( :nth_subclass_of_class_including_module ) { ::Class.new( subclass_of_class_including_module ) }
        let( :nth_module_including_including_module ) do
          _including_module = including_module
          ::Module.new { include( _including_module ) }
        end
        let( :nth_module_extended_by_including_module ) { ::Module.new.extend( including_module ) }
        let( :n_plus_one_module_extended_by_including_module ) do
          ::Module.new.extend( nth_module_including_including_module )
        end
        let( :class_including_nth_including_module ) do
          _nth_module_including_including_module = nth_module_including_including_module
          ::Class.new { include( _nth_module_including_including_module ) }
        end
        let( :subclass_of_class_including_nth_including_module ) { ::Class.new( class_including_nth_including_module ) }
        let( :nth_subclass_of_class_including_nth_including_module ) do
          ::Class.new( subclass_of_class_including_nth_including_module )
        end
        let( :class_extended_by_nth_including_module ) { ::Class.new.extend( nth_module_including_including_module ) }
        let( :subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( class_extended_by_nth_including_module )
        end
        let( :nth_subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( subclass_of_class_extended_by_nth_including_module )
        end
        it 'will create a cascading singleton support module for a module instance' do
          instance_controller.should have_created_support( *create_support_args )
        end
        context 'module including module with instance support' do

          it 'the support module will cascade to an including module' do
            including_module.should_not have_been_extended_by( support_module )
            including_module.should have_included( support_module )
          end

          it 'the support module will cascade to an including class' do
            class_including_module.should_not have_been_extended_by( support_module )
            class_including_module.should have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an including class' do
            subclass_of_class_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_including_module.should have_included( support_module )
          end
          it 'the support module will cascade to any nth subclass of an including class' do
            nth_subclass_of_class_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_including_module.should have_included( support_module )
          end

          it 'an including module will cascade to an nth including module' do
            nth_module_including_including_module.should_not have_been_extended_by( support_module )
            nth_module_including_including_module.should have_included( support_module )
          end

          it 'an including module will not cascade the support module to an nth extending module' do
            nth_module_extended_by_including_module.should have_been_extended_by( support_module )
            nth_module_extended_by_including_module.should_not have_included( support_module )
          end
          it 'an nth extending module will not cascade the support module to an n + 1 extending module' do
            n_plus_one_module_extended_by_including_module.should have_been_extended_by( support_module )
            n_plus_one_module_extended_by_including_module.should_not have_included( support_module )
          end

          it 'an nth including module will cascade the support module to an including class' do
            class_including_nth_including_module.should_not have_been_extended_by( support_module )
            class_including_nth_including_module.should have_included( support_module )
          end
          it 'a class including nth module will cascade the support module to a subclass' do
            subclass_of_class_including_nth_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_including_nth_including_module.should have_included( support_module )
          end
          it 'an nth subclass of class including nth module will cascade the support module to an n + 1 subclass' do
            nth_subclass_of_class_including_nth_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_including_nth_including_module.should have_included( support_module )
          end

          it 'an nth including module will cascade the support module to an extending class' do
            class_extended_by_nth_including_module.should have_been_extended_by( support_module )
            class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'a class extended by nth module will cascade the support module to a subclass due to the Ruby inheritance model' do
            subclass_of_class_extended_by_nth_including_module.should have_been_extended_by( support_module )
            subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'any nth subclass of class extended by nth module will cascade the support module due to the Ruby inheritance model' do
            nth_subclass_of_class_extended_by_nth_including_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          
        end
        context 'module extended by module with instance support' do

          let( :extending_module ) { ::Module.new.extend( instance ) }
          let( :module_including_extended_module ) do
            _extending_module = extending_module
            ::Module.new { include( _extending_module ) }
          end
          let( :module_extended_by_extending_module ) { ::Module.new.extend( extending_module ) }
          
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) { ::Class.new( subclass_of_class_extended_by_extended_module ) }
          
          it 'the support module will cascade to an extending module' do
            extending_module.should have_been_extended_by( support_module )
            extending_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an including module' do
            module_including_extended_module.should_not have_been_extended_by( support_module )
            module_including_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an extending module' do
            module_extended_by_extending_module.should_not have_been_extended_by( support_module )
            module_extended_by_extending_module.should_not have_included( support_module )
          end

          it 'the support module will cascade to an extending class' do
            class_extended_by_extended_module.should have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          
        end
        context 'class including module with instance support' do
          let( :class_extended_by_extended_module ) do
            _module_instance = instance
            ::Class.new { include( _module_instance ) }
          end
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will cascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should have_included( support_module )
          end
          it 'the support module will cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should have_included( support_module )
          end

        end
        context 'class extended by module with instance support' do
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will cascade to an extending class' do
            class_extended_by_extended_module.should have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
        end       
      end
      context 'class instance' do
        let( :instance ) { ::Class.new }
        let( :subclass ) { ::Class.new( instance ) }
        let( :nth_subclass ) { ::Class.new( subclass ) }
        it 'the support module will cascade to a subclass of an extended class' do
          subclass.should_not have_been_extended_by( support_module )
          subclass.should have_included( support_module )
        end
        it 'the support module will cascade to an nth subclass of an extended class' do
          nth_subclass.should_not have_been_extended_by( support_module )
          nth_subclass.should have_included( support_module )
        end
      end

    end

    context 'module_inheritance_model: local instance' do

      let( :module_inheritance_model ) { :local_instance }

      context 'module instance' do
        let( :including_module ) do
          _module_instance = instance
          ::Module.new { include( _module_instance ) }
        end
        let( :class_including_module ) do
          _module_instance = instance
          ::Class.new { include( _module_instance ) }
        end
        let( :subclass_of_class_including_module ) { ::Class.new( class_including_module ) }
        let( :nth_subclass_of_class_including_module ) { ::Class.new( subclass_of_class_including_module ) }
        let( :nth_module_including_including_module ) do
          _including_module = including_module
          ::Module.new { include( _including_module ) }
        end
        let( :nth_module_extended_by_including_module ) { ::Module.new.extend( including_module ) }
        let( :n_plus_one_module_extended_by_including_module ) do
          ::Module.new.extend( nth_module_including_including_module )
        end
        let( :class_including_nth_including_module ) do
          _nth_module_including_including_module = nth_module_including_including_module
          ::Class.new { include( _nth_module_including_including_module ) }
        end
        let( :subclass_of_class_including_nth_including_module ) { ::Class.new( class_including_nth_including_module ) }
        let( :nth_subclass_of_class_including_nth_including_module ) do
          ::Class.new( subclass_of_class_including_nth_including_module )
        end
        let( :class_extended_by_nth_including_module ) { ::Class.new.extend( nth_module_including_including_module ) }
        let( :subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( class_extended_by_nth_including_module )
        end
        let( :nth_subclass_of_class_extended_by_nth_including_module ) do
          ::Class.new( subclass_of_class_extended_by_nth_including_module )
        end
        it 'will create a cascading singleton support module for a module instance' do
          instance_controller.should have_created_support( *create_support_args )
        end
        context 'module including module with local instance support' do

          it 'the support module will not cascade to an including module' do
            including_module.should_not have_been_extended_by( support_module )
            including_module.should_not have_included( support_module )
          end

          it 'the support module will not cascade to an including class' do
            class_including_module.should_not have_been_extended_by( support_module )
            class_including_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an including class' do
            subclass_of_class_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_including_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to any nth subclass of an including class' do
            nth_subclass_of_class_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_including_module.should_not have_included( support_module )
          end

          it 'an including module will not cascade to an nth including module' do
            nth_module_including_including_module.should_not have_been_extended_by( support_module )
            nth_module_including_including_module.should_not have_included( support_module )
          end

          it 'an including module will not cascade the support module to an nth extending module' do
            nth_module_extended_by_including_module.should_not have_been_extended_by( support_module )
            nth_module_extended_by_including_module.should_not have_included( support_module )
          end
          it 'an nth extending module will not cascade the support module to an n + 1 extending module' do
            n_plus_one_module_extended_by_including_module.should_not have_been_extended_by( support_module )
            n_plus_one_module_extended_by_including_module.should_not have_included( support_module )
          end

          it 'an nth including module will not cascade the support module to an including class' do
            class_including_nth_including_module.should_not have_been_extended_by( support_module )
            class_including_nth_including_module.should_not have_included( support_module )
          end
          it 'a class including nth module will not cascade the support module to a subclass' do
            subclass_of_class_including_nth_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_including_nth_including_module.should_not have_included( support_module )
          end
          it 'an nth subclass of class including nth module will not cascade the support module to an n + 1 subclass' do
            nth_subclass_of_class_including_nth_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_including_nth_including_module.should_not have_included( support_module )
          end

          it 'an nth including module will not cascade the support module to an extending class' do
            class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'a class extended by nth module will not cascade the support module to a subclass due to the Ruby inheritance model' do
            subclass_of_class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          it 'any nth subclass of class extended by nth module will not cascade the support module due to the Ruby inheritance model' do
            nth_subclass_of_class_extended_by_nth_including_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_nth_including_module.should_not have_included( support_module )
          end
          
        end
        context 'module extended by module with local instance support' do

          let( :extending_module ) { ::Module.new.extend( instance ) }
          let( :module_including_extended_module ) do
            _extending_module = extending_module
            ::Module.new { include( _extending_module ) }
          end
          let( :module_extended_by_extending_module ) { ::Module.new.extend( extending_module ) }
          
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) { ::Class.new( subclass_of_class_extended_by_extended_module ) }
          
          it 'the support module will not cascade to an extending module' do
            extending_module.should_not have_been_extended_by( support_module )
            extending_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an including module' do
            module_including_extended_module.should_not have_been_extended_by( support_module )
            module_including_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade past an extending module to an extending module' do
            module_extended_by_extending_module.should_not have_been_extended_by( support_module )
            module_extended_by_extending_module.should_not have_included( support_module )
          end

          it 'the support module will not cascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          
        end
        context 'class including module with local instance support' do
          let( :class_extended_by_extended_module ) do
            _module_instance = instance
            ::Class.new { include( _module_instance ) }
          end
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will not cascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end

        end
        context 'class extended by module with local instance support' do
          let( :class_extended_by_extended_module ) { ::Class.new.extend( instance ) }
          let( :subclass_of_class_extended_by_extended_module ) { ::Class.new( class_extended_by_extended_module ) }
          let( :nth_subclass_of_class_extended_by_extended_module ) do
            ::Class.new( subclass_of_class_extended_by_extended_module )
          end
          it 'the support module will not cascade to an extending class' do
            class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to a subclass of an extending class' do
            subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
          it 'the support module will not cascade to an nth subclass of an extending class' do
            nth_subclass_of_class_extended_by_extended_module.should_not have_been_extended_by( support_module )
            nth_subclass_of_class_extended_by_extended_module.should_not have_included( support_module )
          end
        end       
      end
      context 'class instance' do
        let( :instance ) { ::Class.new }
        let( :subclass ) { ::Class.new( instance ) }
        let( :nth_subclass ) { ::Class.new( subclass ) }
        it 'the support module will cascade to a subclass of an extended class' do
          subclass.should have_been_extended_by( support_module )
          subclass.should_not have_included( support_module )
        end
        it 'the support module will cascade to an nth subclass of an extended class' do
          nth_subclass.should have_been_extended_by( support_module )
          nth_subclass.should_not have_included( support_module )
        end
      end

    end

  end
  
  ##################################################################################################
  #   public #######################################################################################
  ##################################################################################################

  ##############################
  #  self.instance_controller  #
  ##############################

  context '::instance_controller' do
    it 'tracks instance controllers for instances' do
      instance_controller.should be ::CascadingConfiguration::InstanceController.instance_controller( instance )
    end
  end

  ##############
  #  instance  #
  ##############
  
  context '#instance' do
    it 'returns its instance' do
      instance_controller.instance.should be instance
    end
    it 'a referene to it is stored in its instance' do
      instance_controller.should be instance::Controller
    end
  end
  
  #############
  #  support  #
  #############

  context '#support' do
    let( :module_type_name ) { :arbitrary_type_name }
    let( :support_module ) do
      _module_type_name = module_type_name
      instance_controller.instance_eval { create_support( _module_type_name ) }
    end
    let( :support ) do
      support_module
      _module_type_name = module_type_name
      instance_controller.instance_eval { support( _module_type_name ) }
    end
    context 'when name is a symbol' do
      let( :request_module_type_name ) { module_type_name }
      it 'will return the named support module' do
        support.should be( support_module )
      end
    end
    context 'when name is a string' do
      let( :request_module_type_name ) { module_type_name.to_s }
      it 'will return the named support module' do
        support.should be( support_module )
      end
    end
  end
   
end
