
require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Core::Module do

  before :all do
    @class_instance = ::CascadingConfiguration::Core::Module.new( :setting, '' ).name( :ClassInstance )
    @ccm = ::Module.new.name( :CCM )
    ::CascadingConfiguration::Core.enable_instance_as_cascading_configuration_module( @ccm, @class_instance )
  end

  ################
  #  initialize  #
  ################

  it 'can initialize with a base name for a default encapsulation and with aliases' do
    @class_instance.module_type_name.should == :setting
    @class_instance.module_type_name_aliases.should == [ '' ]
  end
  
  ###########################
  #  cascading_method_name  #
  ###########################
  
  it 'can return a cascading method name for a base name' do
    @class_instance.module_eval do
      cascading_method_name( 'some_name' ).should == 'attr_some_name'
    end
  end

  ########################
  #  module_method_name  #
  ########################

  it 'can return a module method name for a base name' do
    @class_instance.module_eval do
      module_method_name( 'some_name' ).should == 'attr_module_some_name'
    end
  end

  #######################
  #  class_method_name  #
  #######################

  it 'can return a class method name for a base name' do
    @class_instance.module_eval do
      class_method_name( 'some_name' ).should == 'attr_class_some_name'
    end
  end

  ##########################
  #  instance_method_name  #
  ##########################

  it 'can return an instance method name for a base name' do
    @class_instance.module_eval do
      instance_method_name( 'some_name' ).should == 'attr_instance_some_name'
    end
  end

  ################################
  #  local_instance_method_name  #
  ################################

  it 'can return a local instance method name for a base name' do
    @class_instance.module_eval do
      local_instance_method_name( 'some_name' ).should == 'attr_local_some_name'
    end
  end

  ########################
  #  object_method_name  #
  ########################

  it 'can return an object method name for a base name' do
    @class_instance.module_eval do
      object_method_name( 'some_name' ).should == 'attr_object_some_name'
    end
  end

  ##################################
  #  define_configuration_definer  #
  ##################################

  it 'can define cascading configuration methods' do
    @class_instance.module_eval do
      # all
      define_configuration_definer( :all_base, [ :all_other ], :all )
      method_defined?( :all_base ).should == true
      method_defined?( :all_other ).should == true
      instance_method( :all_base ).should == instance_method( :all_other )
      # module
      define_configuration_definer( :module_base, [ :module_other ], :module )
      method_defined?( :module_base ).should == true
      method_defined?( :module_other ).should == true
      instance_method( :module_base ).should == instance_method( :module_other )
      # instance
      define_configuration_definer( :instance_base, [ :instance_other ], :instance )
      method_defined?( :instance_base ).should == true
      method_defined?( :instance_other ).should == true
      instance_method( :instance_base ).should == instance_method( :instance_other )
      # local_instance
      define_configuration_definer( :local_base, [ :local_other ], :local_instance )
      method_defined?( :local_base ).should == true
      method_defined?( :local_other ).should == true
      instance_method( :local_base ).should == instance_method( :local_other )
      # object
      define_configuration_definer( :object_base, [ :object_other ], :object )
      method_defined?( :object_base ).should == true
      method_defined?( :object_other ).should == true
      instance_method( :object_other ).should == instance_method( :object_base )
    end

    ccm = @ccm
    
    ::Module.new do
      include ccm

      # all
      all_base( :all )

      instance_methods.include?( :all ).should == true
      respond_to?( :all ).should == true

      # module
      module_base( :module )
      instance_methods.include?( :module ).should == false
      respond_to?( :module ).should == true

      # instance
      instance_base( :instance )
      instance_methods.include?( :instance ).should == true
      respond_to?( :instance ).should == false

      # local instance
      local_base( :local_instance )
      instance_methods.include?( :local_instance ).should == true
      respond_to?( :local_instance ).should == true

      # object
      object_base( :object )
      instance_methods.include?( :object ).should == false
      respond_to?( :object ).should == true

    end
  end
  
  ########################################
  #  define_cascading_definition_method  #
  ########################################
  
  it 'can define cascading configuration methods that define cascading configurations' do
    @class_instance.module_eval do

      define_cascading_definition_method( :base, :other )

      method_defined?( :attr_base ).should == true
      method_defined?( :attr_other ).should == true
      instance_method( :attr_base ).should == instance_method( :attr_other )
    end
    
    ccm = @ccm
    
    ::Module.new do
      include ccm
      attr_base( :all )
      instance_methods.include?( :all ).should == true
      respond_to?( :all ).should == true
    end
  end

  #####################################
  #  define_module_definition_method  #
  #####################################

  it 'can define cascading configuration methods that define module configurations' do
    @class_instance.module_eval do
      
      define_module_definition_method( :base, :other )
      
      method_defined?( :attr_module_base ).should == true
      method_defined?( :attr_module_other ).should == true
      instance_method( :attr_module_base ).should == instance_method( :attr_module_other )
    
    end
    
    ccm = @ccm
    
    ::Module.new do
      include ccm
      attr_module_base( :module )
      instance_methods.include?( :module ).should == false
      respond_to?( :module ).should == true
    end
  end

  #######################################
  #  define_instance_definition_method  #
  #######################################

  it 'can define cascading configuration methods that define instance configurations' do
    @class_instance.module_eval do

      define_instance_definition_method( :base, :other )
      
      method_defined?( :attr_instance_base ).should == true
      method_defined?( :attr_instance_other ).should == true
      instance_method( :attr_instance_base ).should == instance_method( :attr_instance_other )
      
    end
    
    ccm = @ccm
    
    ::Module.new do
      include ccm
      module InstanceModule
      end
      attr_instance_base( :instance )
      instance_methods.include?( :instance ).should == true
      respond_to?( :instance ).should == false
    end
  end

  ####################################
  #  define_local_definition_method  #
  ####################################
  
  it 'can define cascading configuration methods that define local configurations' do
    @class_instance.module_eval do
      
      define_local_instance_definition_method( :base, :other )
      
      method_defined?( :attr_local_base ).should == true
      method_defined?( :attr_local_other ).should == true
      instance_method( :attr_local_base ).should == instance_method( :attr_local_other )
      
    end
    
    ccm = @ccm
    
    ::Module.new do
      include ccm
      module LocalInstanceModule
      end
      attr_local_base( :local_instance )
      instance_methods.include?( :local_instance ).should == true
      respond_to?( :local_instance ).should == true
    end
  end
  
  #####################################
  #  define_object_definition_method  #
  #####################################

  it 'can define cascading configuration methods that define object configurations' do
    @class_instance.module_eval do
      
      
      define_object_definition_method( :base, :other )
      
      method_defined?( :attr_object_base ).should == true
      method_defined?( :attr_object_other ).should == true
      instance_method( :attr_object_other ).should == instance_method( :attr_object_base )
    
    end
    
    ccm = @ccm

    ::Module.new do
      include ccm
      module ObjectModule
      end
      attr_object_base( :object )
      instance_methods.include?( :object ).should == false
      respond_to?( :object ).should == true
    end        
  end
  
  #########################################
  #  define_cascading_definition_methods  #
  #########################################
  
  it 'can define cascading configuration methods that define all types of cascading configuration methods' do
    @class_instance.module_eval do
      
      define_cascading_definition_methods( :base, :other )
      
      # all
      method_defined?( :attr_base ).should == true
      method_defined?( :attr_other ).should == true
      instance_method( :attr_base ).should == instance_method( :attr_other )
      
      # module
      method_defined?( :attr_module_base ).should == true
      method_defined?( :attr_module_other ).should == true
      instance_method( :attr_module_base ).should == instance_method( :attr_module_other )
      
      # instance
      method_defined?( :attr_instance_base ).should == true
      method_defined?( :attr_instance_other ).should == true
      instance_method( :attr_instance_base ).should == instance_method( :attr_instance_other )
      
      # local instance
      method_defined?( :attr_local_base ).should == true
      method_defined?( :attr_local_other ).should == true
      instance_method( :attr_local_base ).should == instance_method( :attr_local_other )
      
      # object
      method_defined?( :attr_object_base ).should == true
      method_defined?( :attr_object_other ).should == true
      instance_method( :attr_object_other ).should == instance_method( :attr_object_base )
    
    end
    
    ccm = @ccm
    
    ::Module.new do

      include ccm
      
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
