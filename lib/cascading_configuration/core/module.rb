
class ::CascadingConfiguration::Core::Module < ::Module
  
  DefaultEncapsulationName = :default
  DefaultEncapsulation = ::CascadingConfiguration::Core::Encapsulation.new( DefaultEncapsulationName )
  
  include ::CascadingConfiguration::Core::EnableModuleSupport
  
  ################
  #  initialize  #
  ################
  
  def initialize( ccm_name, 
                  default_encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                  *ccm_aliases )
    
    super()
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( default_encapsulation_or_name )
    
    @default_encapsulation = encapsulation
    
    @ccm_name = ccm_name
    @ccm_aliases = ccm_aliases
    
    define_definition_methods( @ccm_name, *@ccm_aliases )
        
  end

  ###########################
  #  default_encapsulation  #
  ###########################
  
  attr_reader :default_encapsulation

  ##############
  #  ccm_name  #
  ##############
  
  attr_reader :ccm_name

  #################
  #  ccm_aliases  #
  #################
  
  attr_reader :ccm_aliases

  ###############################
  #  define_definition_methods  #
  ###############################
  
  def define_definition_methods( ccm_name, *ccm_aliases )
    
    define_cascading_definition_method( ccm_name, *ccm_aliases )
    define_module_definition_method( ccm_name, *ccm_aliases )
    define_instance_definition_method( ccm_name, *ccm_aliases )
    define_object_definition_method( ccm_name, *ccm_aliases )
    define_local_instance_definition_method( ccm_name, *ccm_aliases )
    
  end
  
  ########################################
  #  define_cascading_definition_method  #
  ########################################
  
  def define_cascading_definition_method( ccm_name, *ccm_aliases )

    ccm_method_name = cascading_method_name( ccm_name )
    ccm_alias_names = ccm_aliases.collect { |this_alias| cascading_method_name( this_alias ) }

    return define_method_with_extension_modules( ccm_method_name, ccm_alias_names, :all )

  end

  #####################################
  #  define_module_definition_method  #
  #####################################

  def define_module_definition_method( ccm_name, *ccm_aliases )
    
    ccm_method_name = module_method_name( ccm_name )
    ccm_alias_names = [ class_method_name( ccm_name ) ]
    ccm_alias_names.concat( ccm_aliases.collect { |this_alias| module_method_name( this_alias ) } )
    ccm_alias_names.concat( ccm_aliases.collect { |this_alias| class_method_name( this_alias ) } )
    
    return define_method_with_extension_modules( ccm_method_name, ccm_alias_names, :module )
    
  end

  #######################################
  #  define_instance_definition_method  #
  #######################################

  def define_instance_definition_method( ccm_name, *ccm_aliases )
    
    ccm_method_name = instance_method_name( ccm_name )
    ccm_alias_names = ccm_aliases.collect { |this_alias| instance_method_name( this_alias ) }
    
    return define_method_with_extension_modules( ccm_method_name, ccm_alias_names, :instance )
    
  end

  #############################################
  #  define_local_instance_definition_method  #
  #############################################

  def define_local_instance_definition_method( ccm_name, *ccm_aliases )
    
    ccm_method_name = local_instance_method_name( ccm_name )
    ccm_alias_names = ccm_aliases.collect { |this_alias| local_instance_method_name( this_alias ) }
    
    return define_method_with_extension_modules( ccm_method_name, ccm_alias_names, :local_instance )
    
  end

  #####################################
  #  define_object_definition_method  #
  #####################################

  def define_object_definition_method( ccm_name, *ccm_aliases )

    ccm_method_name = object_method_name( ccm_name )
    ccm_alias_names = ccm_aliases.collect { |this_alias| object_method_name( this_alias ) }

    return define_method_with_extension_modules( ccm_method_name, ccm_alias_names, :object )
    
  end
   
  ##########################
  #  create_configuration  #
  ##########################

  def create_configuration( encapsulation, instance, name )

    encapsulation.register_configuration( instance, name, self )
    
    return self
    
  end

  ##############################
  #  initialize_configuration  #
  ##############################
  
  def initialize_configuration( encapsulation, instance, name )
    
    # Nothing here - for subclasses to define.
    
  end

  ###########################
  #  define_configurations  #
  ###########################
  
  def define_configurations( instance_controller, encapsulation, method_types, *names, & definer_block )

    accessors = instance_controller.define_configuration_methods( self, encapsulation, method_types, names, & definer_block )
    
    instance = instance_controller.instance
    
    accessors.each do |this_accessor, this_write_accessor|
      create_configuration( encapsulation, instance, this_accessor )
    end
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###########################
  #  cascading_method_name  #
  ###########################
  
  def cascading_method_name( base_name )
    
    return 'attr_' << base_name.to_s
    
  end

  ########################
  #  module_method_name  #
  ########################

  def module_method_name( base_name )

    return 'attr_module_' << base_name.to_s

  end

  #######################
  #  class_method_name  #
  #######################

  def class_method_name( base_name )

    return 'attr_class_' << base_name.to_s

  end

  ##########################
  #  instance_method_name  #
  ##########################

  def instance_method_name( base_name )

    return 'attr_instance_' << base_name.to_s

  end

  ################################
  #  local_instance_method_name  #
  ################################

  def local_instance_method_name( base_name )

    return 'attr_local_' << base_name.to_s

  end

  ########################
  #  object_method_name  #
  ########################

  def object_method_name( base_name )

    return 'attr_object_' << base_name.to_s

  end

  ##########################################
  #  define_method_with_extension_modules  #
  ##########################################

  def define_method_with_extension_modules( ccm_method_name, ccm_aliases, *method_types )
        
    # Methods that define configurations that optionally take modules as parameters as well as a
    # block that will be used to dynamically define an extension module for the instances created
    # by the configurations. 
    # 
    # This defines attr_... :configuration_name, ModuleInstance, ... { ... }
    
    ccm = self
     
    #======================#
    #  ccm_method_name_in  #
    #======================#
     
    ccm_encapsulation_method_name = ccm_method_name.to_s + '_in'

    define_method( ccm_encapsulation_method_name ) do |encapsulation_or_name, *args, & definer_block|
      
      encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name, true )

      instance_controller = ::CascadingConfiguration::Core::InstanceController.instance_controller( self, true )

      ccm.define_configurations( instance_controller, encapsulation, method_types, *args, & definer_block )                  
      
      return self
      
    end

    #===================#
    #  ccm_method_name  #
    #===================#
    
    default_encapsulation = @default_encapsulation_name

    define_method( ccm_method_name ) do |*args, & definer_block|
      
      return __send__( ccm_encapsulation_method_name, default_encapsulation, *args, & definer_block )
      
    end
    
    ccm_aliases.each do |this_alias|
      alias_method( this_alias.to_s + '_in', ccm_encapsulation_method_name )
      alias_method( this_alias, ccm_method_name )
    end
    
    return self
    
  end
   
end
