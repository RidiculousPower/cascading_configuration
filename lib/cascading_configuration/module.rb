
###
# A Configuration Module abstracts and implements all of the primary functionality for
#  CascadingConfiguration modules, permitting simple definition of multiple configuration
#  module types as well as easy extension of configuration types.
#
class ::CascadingConfiguration::Module < ::Module
  
  ###
  # Prefix used for configuration definition methods.
  #
  DefinitionMethodPrefix = 'attr'
    
  ################
  #  initialize  #
  ################
  
  ###
  # @overload new( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #
  #          Name to be used for this configuration module.
  #
  #          This name will be used as the base for all method definition names.
  #
  #          For example: 
  #
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_setting_<configuration_name>.
  #
  #   @param [Symbol,String] module_type_name_alias
  #
  #          Additional names to use for this configuration module.
  #
  #          For example: 
  #
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_setting_<configuration_name>.
  #
  def initialize( module_type_name, *module_type_name_aliases )
    
    super()
    
    @module_type_name = module_type_name
    @module_type_name_aliases = module_type_name_aliases
    
    define_cascading_definition_methods( @module_type_name, *@module_type_name_aliases )
        
  end

  ##############
  #  extended  #
  ##############
  
  ###
  # Extend creates instance support for the instance in which extend occurs.
  #
  def extended( instance )
    
    super if defined?( super )
    
    # Ensure our instance has an instance controller
    unless instance_controller = ::CascadingConfiguration::InstanceController.instance_controller( instance )
      instance_controller = ::CascadingConfiguration::InstanceController.new( instance, true )
    end

    instance_controller.create_singleton_support
    
  end

  ######################
  #  module_type_name  #
  ######################
  
  ###
  # Name used as base for all method definition names.
  #
  #   For example: 
  #   
  #     CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #     :attr_setting_<configuration_name>.
  #
  # @!attribute [r] module_type_name
  #
  # @return [ Symbol ]
  #
  attr_reader :module_type_name

  ##############################
  #  module_type_name_aliases  #
  ##############################
  
  ###
  # Name aliases used for additional method definition names.
  #
  #   For example: 
  #   
  #     CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #     and therefore has the base method name :attr_setting_<configuration_name>.
  #
  # @!attribute [r] module_type_name_aliases
  #
  # @return [ Symbol ]
  #
  attr_reader :module_type_name_aliases

  #########################################
  #  define_cascading_definition_methods  #
  #########################################
  
  ###
  # Define all cascading definition methods.
  #
  # @overload define_cascading_definition_methods( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_setting_<configuration_name>.
  #
  def define_cascading_definition_methods( module_type_name, *module_type_name_aliases )
    
    define_cascading_definition_method( module_type_name, *module_type_name_aliases )
    define_module_definition_method( module_type_name, *module_type_name_aliases )
    define_instance_definition_method( module_type_name, *module_type_name_aliases )
    define_object_definition_method( module_type_name, *module_type_name_aliases )
    define_local_instance_definition_method( module_type_name, *module_type_name_aliases )
    
  end
  
  ########################################
  #  define_cascading_definition_method  #
  ########################################
  
  ###
  # Define a definition method that will cause configurations to cascade through include/extend
  #   for both singletons (Modules and Classes) and instances.
  #
  # @overload define_cascading_definition_method( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_setting_<configuration_name>.
  #
  def define_cascading_definition_method( module_type_name, *module_type_name_aliases )

    ccm_method_name = cascading_method_name( module_type_name )
    ccm_alias_names = module_type_name_aliases.collect { |this_alias| cascading_method_name( this_alias ) }

    return define_configuration_definer( ccm_method_name, ccm_alias_names, :all )

  end

  #####################################
  #  define_module_definition_method  #
  #####################################

  ###
  # Define a definition method that will cause configurations to cascade through include/extend
  #   for singletons (Modules/Classes).
  #
  # @overload define_singleton_definition_method( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_module_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_module_setting_<configuration_name>.
  #
  def define_singleton_definition_method( module_type_name, *module_type_name_aliases )
    
    ccm_method_name = singleton_method_name( module_type_name )
    ccm_alias_names = [ module_method_name( module_type_name ), 
                        class_method_name( module_type_name ) ]
    ccm_alias_names.concat( module_type_name_aliases.collect { |this_alias| singleton_method_name( this_alias ) } )
    ccm_alias_names.concat( module_type_name_aliases.collect { |this_alias| module_method_name( this_alias ) } )
    ccm_alias_names.concat( module_type_name_aliases.collect { |this_alias| class_method_name( this_alias ) } )
    
    return define_configuration_definer( ccm_method_name, ccm_alias_names, :singleton )
    
  end

  #####################################
  #  define_module_definition_method  #
  #####################################
  
  alias_method :define_module_definition_method, :define_singleton_definition_method

  ####################################
  #  define_class_definition_method  #
  ####################################

  alias_method :define_class_definition_method, :define_singleton_definition_method

  #######################################
  #  define_instance_definition_method  #
  #######################################

  ###
  # Define a definition method that will cause configurations to cascade through include/extend
  #   for instances.
  #
  # @overload define_instance_definition_method( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_instance_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_instance_setting_<configuration_name>.
  #
  def define_instance_definition_method( module_type_name, *module_type_name_aliases )
    
    ccm_method_name = instance_method_name( module_type_name )
    ccm_alias_names = module_type_name_aliases.collect { |this_alias| instance_method_name( this_alias ) }
    
    return define_configuration_definer( ccm_method_name, ccm_alias_names, :instance )
    
  end

  #############################################
  #  define_local_instance_definition_method  #
  #############################################

  ###
  # Define a definition method that will create configurations that do not cascade.
  #
  # @overload define_local_instance_definition_method( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_local_instance_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_local_instance_setting_<configuration_name>.
  #
  def define_local_instance_definition_method( module_type_name, *module_type_name_aliases )
    
    ccm_method_name = local_instance_method_name( module_type_name )
    ccm_alias_names = module_type_name_aliases.collect { |this_alias| local_instance_method_name( this_alias ) }
    
    return define_configuration_definer( ccm_method_name, ccm_alias_names, :local_instance )
    
  end

  #####################################
  #  define_object_definition_method  #
  #####################################

  ###
  # Define a definition method that will create configurations for the instance in which they are created
  #   as well as configurations that will cascade through include/extend for instances.
  #
  # @overload define_object_definition_method( module_type_name, module_type_name_alias, ... )
  #
  #   @param [Symbol,String] module_type_name
  #          
  #          Name to be used for this configuration module.
  #          
  #          This name will be used as the base for all method definition names.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #            :attr_object_setting_<configuration_name>.
  #   
  #   @param [Symbol,String] module_type_name_alias
  #          
  #          Additional names to use for this configuration module.
  #          
  #          For example: 
  #          
  #            CascadingConfiguration::Setting has the additional type alias :configuration_setting, 
  #            and therefore has the base method name :attr_object_setting_<configuration_name>.
  #
  def define_object_definition_method( module_type_name, *module_type_name_aliases )

    ccm_method_name = object_method_name( module_type_name )
    ccm_alias_names = module_type_name_aliases.collect { |this_alias| object_method_name( this_alias ) }

    return define_configuration_definer( ccm_method_name, ccm_alias_names, :object )
    
  end

  ###########################
  #  define_configurations  #
  ###########################
  
  ###
  # Define configurations for instance.
  #
  # @overload define_configurations( instance, method_types, configuration_name, ... )
  #
  #   @param [ Object ] instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  #   @param [Array<Symbol,String>] method_types
  #   
  #          Type of method being defined: 
  #   
  #            :all, :module, :class, :instance, :local_instance, :object.
  #
  #   @param [ Symbol, String, Hash{ Symbol, String => Symbol, String } ] configuration_name
  #
  #          Name of configuration to be defined.
  #
  # @return self.
  #
  def define_configurations( instance, method_types, *configuration_names )

    accessors = parse_names_for_accessors( configuration_names )

    accessors.each do |this_configuration_name, this_write_configuration_name|
      define_configuration( instance, method_types, this_configuration_name, this_write_configuration_name )
    end
    
    return self
    
  end

  ##########################
  #  define_configuration  #
  ##########################
  
  ###
  # Define configuration for instance.
  #
  # @param [ Object ] instance
  # 
  #        Instance in which configuration method will be defined.
  # 
  # @param [Array<Symbol,String>] method_types
  # 
  #        Type of method being defined: 
  # 
  #          :all, :module, :class, :instance, :local_instance, :object.
  # 
  # @param [Symbol,String] accessor_name
  # 
  #        Name to use for configuration reader.
  # 
  # @param [Symbol,String] write_accessor_name
  # 
  #        Name to use for configuration writer.
  # 
  # @return self.
  #
  def define_configuration( instance, method_types, accessor_name, write_accessor_name )

    configuration_instance = self.class::Configuration.new( instance, self, accessor_name, write_accessor_name )

    ::CascadingConfiguration.define_configuration( instance, configuration_instance )

    #======================#
    #  configuration_name  #
    #======================#

    getter_proc = ::Proc.new { ::CascadingConfiguration.configuration( self, accessor_name ).value }
    define_configuration_method_types( configuration_instance, accessor_name, getter_proc, method_types )

    #=======================#
    #  configuration_name=  #
    #=======================#

    setter_proc = ::Proc.new { |value| ::CascadingConfiguration.configuration( self, accessor_name ).value = value }    
    define_configuration_method_types( configuration_instance, write_accessor_name, setter_proc, method_types )

    return self
    
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###############################
  #  parse_names_for_accessors  #
  ###############################
  
  ###
  # Parses arguments from configuration definition to normalize configuration names.
  #
  # @param [Array<Symbol,String,Hash{Symbol,String=>Symbol,String}>] configuration_names
  #
  #        Configuration names for both accessor and write accessor or Hash of accessor => write accessor pairs.
  #
  # @return [ Hash{ Symbol, String => Symbol, String } ]
  #
  #         Hash of accessor => write accessor pairs.
  #
  def parse_names_for_accessors( configuration_names )
    
    accessors = { }
    
    configuration_names.each do |this_configuration_name|

      case this_configuration_name

        when ::Hash
        
          this_configuration_name.each do |this_accessor_configuration_name, this_write_accessor_configuration_name|
            this_accessor_name = this_accessor_configuration_name.accessor_name
            this_write_accessor_name = this_write_accessor_configuration_name.write_accessor_name
            accessors[ this_accessor_name ] = this_write_accessor_name
          end
        
        else
        
          accessors[ this_configuration_name.accessor_name ] = this_configuration_name.write_accessor_name
        
      end

    end

    return accessors
    
  end

  ###########################
  #  cascading_method_name  #
  ###########################
  
  ###
  # Construct string for cascading method type (:all) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_setting_<configuration_name>.
  #
  def cascading_method_name( module_type_name )
    
    return self.class::DefinitionMethodPrefix + '_' << module_type_name.to_s
    
  end

  ###########################
  #  singleton_method_name  #
  ###########################

  ###
  # Construct string for cascading method type (:singleton) with singleton type name.
  #
  # @param [Symbol,String] singleton_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_module_setting_<configuration_name>.
  #
  def singleton_method_name( singleton_type_name )

    return self.class::DefinitionMethodPrefix + '_singleton_' << singleton_type_name.to_s

  end

  ########################
  #  module_method_name  #
  ########################

  ###
  # Construct string for cascading method type (:module) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_module_setting_<configuration_name>.
  #
  def module_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix + '_module_' << module_type_name.to_s

  end

  #######################
  #  class_method_name  #
  #######################

  ###
  # Construct string for cascading method type (:class) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_class_setting_<configuration_name>.
  #
  def class_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix + '_class_' << module_type_name.to_s

  end

  ##########################
  #  instance_method_name  #
  ##########################

  ###
  # Construct string for cascading method type (:instance) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_instance_setting_<configuration_name>.
  #
  def instance_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix + '_instance_' << module_type_name.to_s

  end

  ################################
  #  local_instance_method_name  #
  ################################

  ###
  # Construct string for cascading method type (:local_instance) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_local_instance_setting_<configuration_name>.
  #
  def local_instance_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix + '_local_' << module_type_name.to_s

  end

  ########################
  #  object_method_name  #
  ########################

  ###
  # Construct string for cascading method type (:object) with module type name.
  #
  # @param [Symbol,String] module_type_name
  #        
  #        Name to be used for this configuration module.
  #        
  #        This name will be used as the base for all method definition names.
  #        
  #        For example: 
  #        
  #          CascadingConfiguration::Setting uses the type name :setting, and therefore has the base method name 
  #          :attr_object_setting_<configuration_name>.
  #
  def object_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix + '_object_' << module_type_name.to_s

  end

  ##################################
  #  define_configuration_definer  #
  ##################################
  
  ###
  # Define a configuration definition method and aliases.
  #
  # @overload define_configuration_definer( ccm_method_name, module_type_name_aliases, method_type, ... )
  #
  #   @param [Symbol,String] ccm_method_name
  #
  #          Name to use for configuration method.
  #   
  #   @param [Array<Symbol,String>] module_type_name_aliases
  #
  #          Aliases to use for configuration method.
  #   
  #   @param [Symbol,String] method_type
  #
  #          Type of method being defined: 
  #          
  #            :all, :singleton, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_definer( ccm_method_name, module_type_name_aliases, *method_types )
    
    define_configuration_method( ccm_method_name, method_types )
    define_configuration_method_aliases( ccm_method_name, module_type_name_aliases )
    
    return self
    
  end
  
  #################################
  #  define_configuration_method  #
  #################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  # 
  # @param [Array<Symbol,String>] method_types
  # 
  #        Type of method being defined: 
  #        
  #          :all, :singleton, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_method( ccm_method_name, method_types )
    
    ccm = self
     
    #===================#
    #  ccm_method_name  #
    #===================#
    
    define_method( ccm_method_name ) do |*args, & block|

      ccm.define_configurations( self, method_types, *args )                  
      
      return self
      
    end

    return self
    
  end

  #########################################
  #  define_configuration_method_aliases  #
  #########################################
  
  ###
  # Define aliases for a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  # 
  # @param [Array<Symbol,String>] module_type_name_aliases
  # 
  #        Aliases to use for configuration method.
  #   
  # @return Self.
  #
  def define_configuration_method_aliases( ccm_method_name, module_type_name_aliases )

    module_type_name_aliases.each do |this_alias|
      alias_method( this_alias, ccm_method_name )
    end
    
    return self
    
  end

  #######################################
  #  define_configuration_method_types  #
  #######################################
  
  ###
  # Define actual methods for configuration.
  #
  # @param [ CascadingConfiguration::Module::Configuration ] configuration_instance
  #
  #        Configuration instance for which methods are to be defined.
  #
  # @param [Symbol,String] accessor_name
  #
  #        Name of method to be defined.
  #
  # @param [Proc] proc_instance
  #
  #        Proc for method body.
  #
  # @param [Array<Symbol,String>] method_types
  #
  #        Type of method being defined: 
  #        
  #          :all, :singleton, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_method_types( configuration_instance, accessor_name, proc_instance, method_types )
    
    instance = configuration_instance.instance
    instance_controller = ::CascadingConfiguration::InstanceController.instance_controller( instance )

    method_types.each do |this_method_type|
      
      case this_method_type
        
        # Cascades through all includes, module and instance methods
        when :all

          instance_controller.define_singleton_method( accessor_name, & proc_instance )
          instance_controller.define_instance_method_if_support( accessor_name, & proc_instance )
        
        # Module methods only
        when :singleton, :module, :class
        
          instance_controller.define_singleton_method( accessor_name, & proc_instance )
        
        # Instance methods only
        when :instance

          instance_controller.define_instance_method( accessor_name, & proc_instance )
        
        # Methods local to this instance and instances of it only
        when :local_instance
        
          instance_controller.define_local_instance_method( accessor_name, & proc_instance )
          instance_controller.define_instance_method_if_support( accessor_name, & proc_instance )

        # Methods local to this instance only
        when :object

          instance_controller.define_local_instance_method( accessor_name, & proc_instance )
        
      end
      
    end
    
    return self
    
  end
   
end
