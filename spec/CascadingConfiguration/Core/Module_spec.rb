
require_relative '../../../lib/cascading-configuration.rb'

describe ::CascadingConfiguration::Core::Module do

  ################
  #  initialize  #
  ################

  it 'can initialize with a base name for a default encapsulation and with aliases' do
    module ::CascadingConfiguration::Core::Module::InitializeMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.default_encapsulation.should == ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      CCM::ClassInstance.ccm_name.should == :setting
      CCM::ClassInstance.ccm_aliases.should == [ '' ]
    end
  end
  
  ###########################
  #  cascading_method_name  #
  ###########################
  
  it 'can return a cascading method name for a base name' do
    module ::CascadingConfiguration::Core::Module::CascadingMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        cascading_method_name( 'some_name' ).should == 'attr_some_name'
      end
    end
  end

  ########################
  #  module_method_name  #
  ########################

  it 'can return a module method name for a base name' do
    module ::CascadingConfiguration::Core::Module::ModuleMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        module_method_name( 'some_name' ).should == 'attr_module_some_name'
      end
    end
  end

  #######################
  #  class_method_name  #
  #######################

  it 'can return a class method name for a base name' do
    module ::CascadingConfiguration::Core::Module::ClassMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        class_method_name( 'some_name' ).should == 'attr_class_some_name'
      end
    end
  end

  ##########################
  #  instance_method_name  #
  ##########################

  it 'can return an instance method name for a base name' do
    module ::CascadingConfiguration::Core::Module::InstanceMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        instance_method_name( 'some_name' ).should == 'attr_instance_some_name'
      end
    end
  end

  ################################
  #  local_method_name  #
  ################################

  it 'can return a local instance method name for a base name' do
    module ::CascadingConfiguration::Core::Module::LocalInstanceMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        local_instance_method_name( 'some_name' ).should == 'attr_local_some_name'
      end
    end
  end

  ########################
  #  object_method_name  #
  ########################

  it 'can return an object method name for a base name' do
    module ::CascadingConfiguration::Core::Module::ObjectMethodNameMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        object_method_name( 'some_name' ).should == 'attr_object_some_name'
      end
    end
  end

  ##########################################
  #  define_method_with_extension_modules  #
  ##########################################

  it 'can define cascading configuration methods' do
    module ::CascadingConfiguration::Core::Module::DefineMethodWithExtensionModulesMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' ) do
        def self.create_configuration( encapsulation, instance, name )
          super
          @called_create_configuration = true
        end
        def self.called_create_configuration?
          returning_called_create_configuration = @called_create_configuration
          @called_create_configuration = false
          return returning_called_create_configuration
        end
      end
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        # all
        define_method_with_extension_modules( :all_base, [ :all_other ], :all )
        method_defined?( :all_base ).should == true
        method_defined?( :all_other ).should == true
        method_defined?( :all_base_in ).should == true
        method_defined?( :all_other_in ).should == true
        instance_method( :all_base ).should == instance_method( :all_other )
        instance_method( :all_base_in ).should == instance_method( :all_other_in )
        # module
        define_method_with_extension_modules( :module_base, [ :module_other ], :module )
        method_defined?( :module_base ).should == true
        method_defined?( :module_other ).should == true
        method_defined?( :module_base_in ).should == true
        method_defined?( :module_other_in ).should == true
        instance_method( :module_base ).should == instance_method( :module_other )
        instance_method( :module_base_in ).should == instance_method( :module_other_in )
        # instance
        define_method_with_extension_modules( :instance_base, [ :instance_other ], :instance )
        method_defined?( :instance_base ).should == true
        method_defined?( :instance_other ).should == true
        method_defined?( :instance_base_in ).should == true
        method_defined?( :instance_other_in ).should == true
        instance_method( :instance_base ).should == instance_method( :instance_other )
        instance_method( :instance_base_in ).should == instance_method( :instance_other_in )
        # local_instance
        define_method_with_extension_modules( :local_base, [ :local_other ], :local_instance )
        method_defined?( :local_base ).should == true
        method_defined?( :local_other ).should == true
        method_defined?( :local_base_in ).should == true
        method_defined?( :local_other_in ).should == true
        instance_method( :local_base ).should == instance_method( :local_other )
        instance_method( :local_base_in ).should == instance_method( :local_other_in )
        # object
        define_method_with_extension_modules( :object_base, [ :object_other ], :object )
        method_defined?( :object_base ).should == true
        method_defined?( :object_other ).should == true
        method_defined?( :object_base_in ).should == true
        method_defined?( :object_other_in ).should == true
        instance_method( :object_other ).should == instance_method( :object_base )
        instance_method( :object_other_in ).should == instance_method( :object_base_in )
      end
      module MethodTestMock
        
        include CCM

        # all
        all_base( :all )

        instance_methods.include?( :all ).should == true
        respond_to?( :all ).should == true
        CCM::ClassInstance.called_create_configuration?.should == true

        # module
        module_base( :module )
        instance_methods.include?( :module ).should == false
        respond_to?( :module ).should == true
        CCM::ClassInstance.called_create_configuration?.should == true

        # instance
        instance_base( :instance )
        instance_methods.include?( :instance ).should == true
        respond_to?( :instance ).should == false
        CCM::ClassInstance.called_create_configuration?.should == true

        # local instance
        local_base( :local_instance )
        instance_methods.include?( :local_instance ).should == true
        respond_to?( :local_instance ).should == true
        CCM::ClassInstance.called_create_configuration?.should == true

        # object
        object_base( :object )
        instance_methods.include?( :object ).should == false
        respond_to?( :object ).should == true
        CCM::ClassInstance.called_create_configuration?.should == true

      end
    end
  end
  
  ########################################
  #  define_cascading_definition_method  #
  ########################################
  
  it 'can define cascading configuration methods that define cascading configurations' do
    module ::CascadingConfiguration::Core::Module::DefineCascadingDefinitionMethodMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do

        define_cascading_definition_method( :base, :other )

        method_defined?( :attr_base ).should == true
        method_defined?( :attr_other ).should == true
        method_defined?( :attr_base_in ).should == true
        method_defined?( :attr_other_in ).should == true
        instance_method( :attr_base ).should == instance_method( :attr_other )
        instance_method( :attr_base_in ).should == instance_method( :attr_other_in )

        module MethodTestMock
          include CCM
          attr_base( :all )
          instance_methods.include?( :all ).should == true
          respond_to?( :all ).should == true
        end
      end
    end
  end

  #####################################
  #  define_module_definition_method  #
  #####################################

  it 'can define cascading configuration methods that define module configurations' do
    module ::CascadingConfiguration::Core::Module::DefineModuleDefinitionMethodMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        
        define_module_definition_method( :base, :other )
        
        method_defined?( :attr_module_base ).should == true
        method_defined?( :attr_module_other ).should == true
        method_defined?( :attr_module_base_in ).should == true
        method_defined?( :attr_module_other_in ).should == true
        instance_method( :attr_module_base ).should == instance_method( :attr_module_other )
        instance_method( :attr_module_base_in ).should == instance_method( :attr_module_other_in )
        
        module MethodTestMock
          include CCM
          attr_module_base( :module )
          instance_methods.include?( :module ).should == false
          respond_to?( :module ).should == true
        end
      end
    end
  end

  #######################################
  #  define_instance_definition_method  #
  #######################################

  it 'can define cascading configuration methods that define instance configurations' do
    module ::CascadingConfiguration::Core::Module::DefineInstanceDefinitionMethodMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do

        define_instance_definition_method( :base, :other )
        
        method_defined?( :attr_instance_base ).should == true
        method_defined?( :attr_instance_other ).should == true
        method_defined?( :attr_instance_base_in ).should == true
        method_defined?( :attr_instance_other_in ).should == true
        instance_method( :attr_instance_base ).should == instance_method( :attr_instance_other )
        instance_method( :attr_instance_base_in ).should == instance_method( :attr_instance_other_in )
        
        module MethodTestMock
          include CCM
          module InstanceModule
          end
          attr_instance_base( :instance )
          instance_methods.include?( :instance ).should == true
          respond_to?( :instance ).should == false
        end
      end
    end
  end

  #############################################
  #  define_local_definition_method  #
  #############################################
  
  it 'can define cascading configuration methods that define local configurations' do
    module ::CascadingConfiguration::Core::Module::DefineLocalInstanceDefinitionMethodMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        
        define_local_instance_definition_method( :base, :other )
        
        method_defined?( :attr_local_base ).should == true
        method_defined?( :attr_local_other ).should == true
        method_defined?( :attr_local_base_in ).should == true
        method_defined?( :attr_local_other_in ).should == true
        instance_method( :attr_local_base ).should == instance_method( :attr_local_other )
        instance_method( :attr_local_base_in ).should == instance_method( :attr_local_other_in )
        
        module MethodTestMock
          include CCM
          module LocalInstanceModule
          end
          attr_local_base( :local_instance )
          instance_methods.include?( :local_instance ).should == true
          respond_to?( :local_instance ).should == true
        end
      end
    end
  end
  
  #####################################
  #  define_object_definition_method  #
  #####################################

  it 'can define cascading configuration methods that define object configurations' do
    module ::CascadingConfiguration::Core::Module::DefineObjectDefinitionMethodMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        
        
        define_object_definition_method( :base, :other )
        
        method_defined?( :attr_object_base ).should == true
        method_defined?( :attr_object_other ).should == true
        method_defined?( :attr_object_base_in ).should == true
        method_defined?( :attr_object_other_in ).should == true
        instance_method( :attr_object_other ).should == instance_method( :attr_object_base )
        instance_method( :attr_object_other_in ).should == instance_method( :attr_object_base_in )

        module MethodTestMock
          include CCM
          module ObjectModule
          end
          attr_object_base( :object )
          instance_methods.include?( :object ).should == false
          respond_to?( :object ).should == true
        end        
      end
    end
  end
  
  ###############################
  #  define_definition_methods  #
  ###############################
  
  it 'can define cascading configuration methods that define all types of cascading configuration methods' do
    module ::CascadingConfiguration::Core::Module::DefineDefinitionMethodsMock
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.module_eval do
        
        define_definition_methods( :base, :other )
        
        # all
        method_defined?( :attr_base ).should == true
        method_defined?( :attr_other ).should == true
        method_defined?( :attr_base_in ).should == true
        method_defined?( :attr_other_in ).should == true
        instance_method( :attr_base ).should == instance_method( :attr_other )
        instance_method( :attr_base_in ).should == instance_method( :attr_other_in )
        
        # module
        method_defined?( :attr_module_base ).should == true
        method_defined?( :attr_module_other ).should == true
        method_defined?( :attr_module_base_in ).should == true
        method_defined?( :attr_module_other_in ).should == true
        instance_method( :attr_module_base ).should == instance_method( :attr_module_other )
        instance_method( :attr_module_base_in ).should == instance_method( :attr_module_other_in )
        
        # instance
        method_defined?( :attr_instance_base ).should == true
        method_defined?( :attr_instance_other ).should == true
        method_defined?( :attr_instance_base_in ).should == true
        method_defined?( :attr_instance_other_in ).should == true
        instance_method( :attr_instance_base ).should == instance_method( :attr_instance_other )
        instance_method( :attr_instance_base_in ).should == instance_method( :attr_instance_other_in )
        
        # local instance
        method_defined?( :attr_local_base ).should == true
        method_defined?( :attr_local_other ).should == true
        method_defined?( :attr_local_base_in ).should == true
        method_defined?( :attr_local_other_in ).should == true
        instance_method( :attr_local_base ).should == instance_method( :attr_local_other )
        instance_method( :attr_local_base_in ).should == instance_method( :attr_local_other_in )
        
        # object
        method_defined?( :attr_object_base ).should == true
        method_defined?( :attr_object_other ).should == true
        method_defined?( :attr_object_base_in ).should == true
        method_defined?( :attr_object_other_in ).should == true
        instance_method( :attr_object_other ).should == instance_method( :attr_object_base )
        instance_method( :attr_object_other_in ).should == instance_method( :attr_object_base_in )
        
        module MethodTestMock
          include CCM
          
          # all
          attr_base( :all ) do
          end
          instance_methods.include?( :all ).should == true
          respond_to?( :all ).should == true
          
          # module
          attr_module_base( :module ) do
          end
          instance_methods.include?( :module ).should == false
          respond_to?( :module ).should == true
          
          # instance
          attr_instance_base( :instance ) do
          end
          instance_methods.include?( :instance ).should == true
          respond_to?( :instance ).should == false
          
          # local instance
          attr_local_base( :local_instance ) do
          end
          instance_methods.include?( :local_instance ).should == true
          respond_to?( :local_instance ).should == true

          # object
          attr_object_base( :object ) do
          end
          instance_methods.include?( :object ).should == false
          respond_to?( :object ).should == true
        end        
        
      end
    end
  end

  ##########################
  #  create_configuration  #
  ##########################

  it 'can create configurations for instances' do
    module ::CascadingConfiguration::Core::Module::CreateConfigurationMock
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      ClassInstance = ::CascadingConfiguration::Core::Module.new( :setting, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.create_configuration( Encapsulation, ForInstance, :some_configuration )
      Encapsulation.has_configuration?( ForInstance, :some_configuration ).should == true
    end
  end

end
