# -*- encoding : utf-8 -*-

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
    
    # set default controller; changed when call is made to register_configuration_module
    @controller = ::CascadingConfiguration
    
  end
  
  ################
  #  controller  #
  ################
  
  ###
  # Refers to Controller singleton used to hold configurations.
  #
  # @!attribute [r] controller
  #
  # @return [CascadingConfiguration::Controller,nil]
  #
  attr_accessor :controller
  
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

  ###########################
  #  cascading_method_name  #
  ###########################
  
  ###
  # Construct string for cascading method type (:singleton_and_instance) with module type name.
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
    
    return self.class::DefinitionMethodPrefix.dup << '_' << module_type_name.to_s
    
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

    return self.class::DefinitionMethodPrefix.dup << '_singleton_' << singleton_type_name.to_s

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

    return self.class::DefinitionMethodPrefix.dup << '_module_' << module_type_name.to_s

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

    return self.class::DefinitionMethodPrefix.dup << '_class_' << module_type_name.to_s

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

    return self.class::DefinitionMethodPrefix.dup << '_instance_' << module_type_name.to_s

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

    return self.class::DefinitionMethodPrefix.dup << '_object_' << module_type_name.to_s

  end

  #################################
  #  local_instance_method_name  #
  #################################

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
  #          :attr_object_setting_<configuration_name>.
  #
  def local_instance_method_name( module_type_name )

    return self.class::DefinitionMethodPrefix.dup << '_local_instance_' << module_type_name.to_s

  end

  ############################
  #  configuration_accessor  #
  ############################
  
  def configuration_accessor( accessor )
    
    return '•' << accessor.to_s
    
  end
  
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
    define_singleton_definition_method( module_type_name, *module_type_name_aliases )
    define_instance_definition_method( module_type_name, *module_type_name_aliases )
    define_local_instance_definition_method( module_type_name, *module_type_name_aliases )
    define_object_definition_method( module_type_name, *module_type_name_aliases )
    
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
    define_cascading_configuration_definition_method( ccm_method_name )
    module_type_name_aliases.each { |this_alias| alias_method( cascading_method_name( this_alias ), ccm_method_name ) }
    
    return self

  end

  ########################################
  #  define_singleton_definition_method  #
  ########################################

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
    
    define_singleton_configuration_definition_method( ccm_method_name )

    alias_method( class_method_name( module_type_name ), ccm_method_name )
    alias_method( module_method_name( module_type_name ), ccm_method_name )
    module_type_name_aliases.each do |this_alias|
      alias_method( singleton_method_name( this_alias ), ccm_method_name )
      alias_method( module_method_name( this_alias ), ccm_method_name )
      alias_method( class_method_name( this_alias ), ccm_method_name )
    end
    
    return self
    
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
    
    define_instance_configuration_definition_method( ccm_method_name )

    module_type_name_aliases.each { |this_alias| alias_method( instance_method_name( this_alias ), ccm_method_name ) }
    
    return self
    
  end

  #####################################
  #  define_object_definition_method  #
  #####################################

  ###
  # Define a definition method that will create configurations that do not cascade.
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
    
    define_object_configuration_definition_method( ccm_method_name )
    module_type_name_aliases.each { |this_alias| alias_method( object_method_name( this_alias ), ccm_method_name ) }

    return self
    
  end

  ##############################################
  #  define_local_instance_definition_method  #
  ##############################################

  ###
  # Define a definition method that will create configurations for the instance in which they are created
  #   as well as configurations that will cascade through include/extend for instances.
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

    define_local_instance_configuration_definition_method( ccm_method_name )

    module_type_name_aliases.each do |this_alias| 
      alias_method( local_instance_method_name( this_alias ), ccm_method_name )
    end

    return self
    
  end
  
  ####################################
  #  define_singleton_configuration  #
  ####################################
  
  def define_singleton_configuration( instance, accessor, write_accessor, *parsed_args, & block )
    
    configuration = self.class::Configuration.new( instance, self, accessor, write_accessor, *parsed_args, & block )
    @controller.singleton_configurations( instance )[ accessor ] = configuration

    return configuration
    
  end
  
  ###################################
  #  define_instance_configuration  #
  ###################################
  
  def define_instance_configuration( instance, accessor, write_accessor, *parsed_args, & block )
    
    parent_configuration = nil

    
    unless parent_configuration = @controller.local_instance_configuration( instance, accessor, false )
      parent_configuration = @controller.singleton_configuration( instance, accessor, false )
    end if ::Module === instance

    configuration = parent_configuration ? parent_configuration
                                         : self.class::Configuration.new( instance, 
                                                                          self, 
                                                                          accessor, 
                                                                          write_accessor, 
                                                                          *parsed_args, 
                                                                          & block )
    
    @controller.instance_configurations( instance )[ accessor ] = configuration
    
    return configuration
    
  end
  
  #################################
  #  define_object_configuration  #
  #################################
  
  def define_object_configuration( instance, accessor, write_accessor, *parsed_args, & block )

    local_instance_configuration = define_local_instance_configuration( instance, 
                                                                        accessor, 
                                                                        write_accessor, 
                                                                        *parsed_args, 
                                                                        & block )
    
    if ::Module === instance
      object_configuration = local_instance_configuration.new«inheriting_configuration»( instance )
      @controller.object_configurations( instance )[ accessor ] = object_configuration
    end

    return local_instance_configuration
    
  end
  
  ##########################################
  #  define_local_instance_configuration  #
  ##########################################
  
  def define_local_instance_configuration( instance, accessor, write_accessor, *parsed_args, & block )
    
    local_instance_configuration = self.class::Configuration.new( instance, 
                                                                  self, 
                                                                  accessor, 
                                                                  write_accessor, 
                                                                  *parsed_args, 
                                                                  & block )
    
    @controller.local_instance_configurations( instance )[ accessor ] = local_instance_configuration
    
    return local_instance_configuration
    
  end

  ########################################
  #  configuration_instance_getter_proc  #
  ########################################

  def configuration_instance_getter_proc( instance, configuration_name )
    
    controller = @controller
    
    #=======================#
    #  •configuration_name  #
    #=======================#

    return ::Proc.new { controller.configuration( self, configuration_name ) }
    
  end
  
  #####################################
  #  configuration_value_getter_proc  #
  #####################################
  
  def configuration_value_getter_proc( instance, configuration_name )

    controller = @controller

    #======================#
    #  configuration_name  #
    #======================#
    
    return ::Proc.new { controller.configuration( self, configuration_name ).value }

  end

  #####################################
  #  configuration_value_setter_proc  #
  #####################################

  def configuration_value_setter_proc( instance, configuration_name )
    
    controller = @controller
    
    #=======================#
    #  configuration_name=  #
    #=======================#
    
    return ::Proc.new { |value| controller.configuration( self, configuration_name ).value = value }
    
  end
  
  #####################################
  #  parse_configuration_descriptors  #
  #####################################
  
  ###
  # Parses arguments from configuration definition to normalize configuration names.
  #
  # @overload parse_configuration_descriptors( instance, configuration_name, ... )
  #
  #   @param [Object] instance
  #
  #          Instance defining configuration.
  #
  #   @param [Symbol,String,Hash] configuration_name
  #
  #          Configuration names for both accessor and write accessor or Hash of accessor => write accessor pairs.
  #
  # @return [Array<Hash{Symbol,String=>Symbol,String},Array<parsed_args>>]
  #
  #         Hash of accessor => write accessor pairs, array of parsed args.
  #
  def parse_configuration_descriptors( instance, *descriptors )
    
    accessors = { }
    parsed_args = nil
    
    descriptors.each do |this_descriptor|
      case this_descriptor
        when ::Hash
          this_descriptor.each do |this_accessor_configuration_name, this_write_accessor_configuration_name|
            this_accessor_name = this_accessor_configuration_name.accessor_name
            this_write_accessor_name = this_write_accessor_configuration_name.write_accessor_name
            accessors[ this_accessor_name ] = this_write_accessor_name
          end
        when ::Symbol, ::String
          accessors[ this_descriptor.accessor_name ] = this_descriptor.write_accessor_name
        else
          parsed_args ||= [ ]
          parsed_args.push( this_descriptor )
      end
    end

    return parsed_args ? [ accessors, parsed_args ] : accessors
    
  end

  ######################################################
  #  define_cascading_configuration_definition_method  #
  ######################################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  #
  # @return Self.
  #
  def define_cascading_configuration_definition_method( ccm_method_name )
    
    ccm = self
     
    #========================#
    #  attr_ccm_method_name  #
    #========================#
    
    define_method( ccm_method_name ) do |*args, & block|
      
      configurations, parsed_args = ccm.parse_configuration_descriptors( self, *args, & block )

      configurations.each do |this_accessor, this_write_accessor|
        ccm.define_singleton_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
        ccm.define_instance_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
      end
      
      return self
      
    end

    return self
    
  end
  
  ######################################################
  #  define_singleton_configuration_definition_method  #
  ######################################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  #
  # @return Self.
  #
  def define_singleton_configuration_definition_method( ccm_method_name )
    
    ccm = self
     
    #==================================#
    #  attr_singleton_ccm_method_name  #
    #  attr_module_ccm_method_name     #
    #  attr_class_ccm_method_name      #
    #==================================#
    
    define_method( ccm_method_name ) do |*args, & block|

      configurations, parsed_args = ccm.parse_configuration_descriptors( self, *args, & block )

      configurations.each do |this_accessor, this_write_accessor|
        ccm.define_singleton_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
      end
      
      return self
      
    end

    return self
    
  end

  #####################################################
  #  define_instance_configuration_definition_method  #
  #####################################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  #
  # @return Self.
  #
  def define_instance_configuration_definition_method( ccm_method_name )
    
    ccm = self
     
    #=================================#
    #  attr_instance_ccm_method_name  #
    #=================================#
    
    define_method( ccm_method_name ) do |*args, & block|
      
      configurations, parsed_args = ccm.parse_configuration_descriptors( self, *args, & block )

      configurations.each do |this_accessor, this_write_accessor|
        ccm.define_instance_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
      end
      
      return self
      
    end

    return self
    
  end

  ###################################################
  #  define_object_configuration_definition_method  #
  ###################################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  #
  # @return Self.
  #
  def define_object_configuration_definition_method( ccm_method_name )
    
    ccm = self
     
    #===============================#
    #  attr_object_ccm_method_name  #
    #===============================#
    
    define_method( ccm_method_name ) do |*args, & block|

      configurations, parsed_args = ccm.parse_configuration_descriptors( self, *args, & block )

      configurations.each do |this_accessor, this_write_accessor|
        ccm.define_object_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
      end
      
      return self
      
    end

    return self
    
  end

  ############################################################
  #  define_local_instance_configuration_definition_method  #
  ############################################################

  ###
  # Define a configuration definition method.
  #
  # @param [Symbol,String] ccm_method_name
  # 
  #        Name to use for configuration method.
  #
  # @return Self.
  #
  def define_local_instance_configuration_definition_method( ccm_method_name )
    
    ccm = self
     
    #========================================#
    #  attr_local_instance_ccm_method_name  #
    #========================================#
    
    define_method( ccm_method_name ) do |*args, & block|

      configurations, parsed_args = ccm.parse_configuration_descriptors( self, *args, & block )

      configurations.each do |this_accessor, this_write_accessor|
        ccm.define_local_instance_configuration( self, this_accessor, this_write_accessor, *parsed_args, & block )
      end
      
      return self
      
    end

    return self
    
  end
   
end
