# -*- encoding : utf-8 -*-

###
# @private
#
# Each declared configuration is backed by a Configuration object, 
#   which manages details specific to the configuration.
#
class ::CascadingConfiguration::Module::Configuration
  
  ########################################
  #  self.new«inheriting_configuration»  #
  ########################################
  
  def self.new«inheriting_configuration»( for_instance, parent_configuration, event = nil, & block )
    
    instance = allocate
    instance.initialize«inheriting_configuration»( for_instance, parent_configuration, event, & block )
    
    return instance
    
  end

  ###############################################
  #  self.new«inheriting_object_configuration»  #
  ###############################################
  
  def self.new«inheriting_object_configuration»( for_instance, parent_configuration, event = nil, & block )
    
    return new«inheriting_configuration»( for_instance, parent_configuration.parent, event, & block )

  end

  #################################################
  #  self.new«inheriting_inactive_configuration»  #
  #################################################
  
  def self.new«inheriting_inactive_configuration»( for_instance, parent_configuration, event = nil, & block )

    instance = parent_configuration.new«configuration_without_parent»( for_instance, event, & block )
    instance.initialize«inheriting_inactive_configuration»( parent_configuration, event )
    
    return instance

  end
  
  ###################################
  #  new«inheriting_configuration»  #
  ###################################
  
  def new«inheriting_configuration»( for_instance, event = nil, & block )
    
    return self.class.new«inheriting_configuration»( for_instance, self, event, & block )
    
  end

  ##########################################
  #  new«inheriting_object_configuration»  #
  ##########################################
  
  def new«inheriting_object_configuration»( for_instance, event = nil, & block )
    
    return self.class.new«inheriting_object_configuration»( for_instance, self, event, & block )
    
  end
  
  #######################################
  #  new«configuration_without_parent»  #
  #######################################
  
  def new«configuration_without_parent»( for_instance, event = nil, & block )
    
    return self.class.new( for_instance, @module, @name, @write_name, & block )
    
  end

  ############################################
  #  new«inheriting_inactive_configuration»  #
  ############################################
  
  def new«inheriting_inactive_configuration»( for_instance, event = nil, & block )
    
    return self.class.new«inheriting_inactive_configuration»( for_instance, self, event, & block )
    
  end

  ################
  #  initialize  #
  ################
  
  def initialize( for_instance, configuration_module, name, write_name = name.write_accessor, *parsed_args, & block )

    @module = configuration_module
    @name = name
    @write_name = write_name

    initialize«common_values»( for_instance, *parsed_args, & block )
    initialize«common_finalize»( for_instance, *parsed_args, & block )    

  end
  
  ##########################################
  #  initialize«inheriting_configuration»  #
  ##########################################
  
  def initialize«inheriting_configuration»( for_instance, parent_configuration, event = nil, *parsed_args, & block )
  
    @module = parent_configuration.module
    @name = parent_configuration.name
    @write_name = parent_configuration.write_name

    initialize«common_values»( for_instance, *parsed_args, & block )    
    initialize«parent_registration»( parent_configuration, event )
    initialize«common_finalize»( for_instance, *parsed_args, & block )    
    
  end
  
  ###################################################
  #  initialize«inheriting_inactive_configuration»  #
  ###################################################
  
  def initialize«inheriting_inactive_configuration»( parent_configuration, event = nil, & block )

    event ? register_inactive_parent( parent_configuration ) 
          : register_inactive_parent_for_ruby_hierarchy( parent_configuration )

  end
  
  ###############################
  #  initialize«common_values»  #
  ###############################
  
  def initialize«common_values»( for_instance, *parsed_args, & block )

    @instance = for_instance
    @has_value = false
    initialize«for_instance»
    
  end

  #################################
  #  initialize«common_finalize»  #
  #################################
  
  def initialize«common_finalize»( for_instance, *parsed_args, & block )

    # nothing here - reserved for definition by subclasses
    
  end
  
  #####################################
  #  initialize«parent_registration»  #
  #####################################
  
  def initialize«parent_registration»( parent_configuration, event = nil )

    event ? register_parent_for_ruby_hierarchy( parent_configuration ) 
          : register_parent( parent_configuration )

  end
  
  ##############################
  #  initialize«for_instance»  #
  ##############################
  
  ###
  # @private
  #
  # Extends self with appropriate module(s) given instance for which initilization is occuring.
  #
  def initialize«for_instance»

    # If we are defining configurations on ::Class we can only have explicit parents.
    case @instance
      when ::Class
        extend( self.class::ClassConfiguration )
        if @instance.equal?( ::Class )
          extend( self.class::ClassInstanceConfiguration )
        elsif ( instance_class = @instance.class ) < ::Module and not instance_class < ::Class
          extend( self.class::ClassInheritingFromModuleConfiguration )
        end
      when ::Module
        extend( self.class::ModuleConfiguration )
      else
        extend( self.class::InstanceConfiguration )
    end
    
  end
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  ###
  # Query whether configuration permits multiple parents.
  #
  # @return [false]
  #
  #         Whether multiple parents are permitted.
  #
  def permits_multiple_parents?
    
    return false
    
  end

  #################################################
  #  configuration_for_configuration_or_instance  #
  #################################################
  
  def configuration_for_configuration_or_instance( configuration_or_instance )
        
    return case configuration_or_instance
      when ::CascadingConfiguration::Module::Configuration
        configuration_or_instance
      else
        controller = @module.controller
        if controller.has_configuration?( configuration_or_instance, @name )
          controller.configuration( configuration_or_instance, @name )
        else
          nil
        end
    end
    
  end

  ############
  #  parent  #
  ############

  ###
  # Get parent for configuration name on instance.
  #
  # @return [Object]
  #
  #         Parent instance registered for configuration.
  #
  attr_reader :parent

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #   Does nothing, serves as placeholder.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( parent )
    
    @parent = parent
    
    return self
    
  end

  ##############################
  #  register_inactive_parent  #
  ##############################
  
  ###
  # Register configuration for inactive parent instance, which means that singleton parent does not exist.
  #   Does nothing, serves as placeholder.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_inactive_parent( parent )
    
    # nothing here - subclasses override
    
    return self
    
  end

  #################################################
  #  register_inactive_parent_for_ruby_hierarchy  #
  #################################################
  
  ###
  # Register configuration for inactive parent instance, which means that singleton parent does not exist.
  #   Does nothing, serves as placeholder.
  #
  # @overload register_parent( parent, ... )
  #
  #   @param parent
  #   
  #          Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_inactive_parent_for_ruby_hierarchy( parent )
    
    # nothing here - subclasses override
    
    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################

  ###
  # Remove a current parent for configuration instance.
  #   Does nothing, serves as placeholder.
  #
  # @param existing_parent
  #
  #        Current parent instance to replace.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def unregister_parent( existing_parent )
    
    @parent = nil
    
    return self
    
  end
  
  ####################
  #  replace_parent  #
  ####################

  ###
  # Replace a current parent for configuration instance with a different parent.
  #
  # @param existing_parent
  #
  #        Current parent instance to replace.
  #
  # @param new_parent
  #
  #        New parent instance.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def replace_parent( existing_parent, new_parent )

    unregister_parent( existing_parent )
    register_parent( new_parent )

    return self

  end
  
  ################
  #  is_parent?  #
  ################
  
  def is_parent?( parent )
    
    return @parent.equal?( parent )
    
  end
  
  ########################################
  #  register_parent_for_ruby_hierarchy  #
  ########################################
  
  alias_method :register_parent_for_ruby_hierarchy, :register_parent

  ##############
  #  instance  #
  ##############
  
  ###
  # Instance for which configuration exists.
  #
  # @!attribute [r] instance
  #
  # @return [Object] instance.
  #
  attr_reader :instance
  
  ##########
  #  name  #
  ##########
  
  ###
  # Configuration name and read accessor.
  #
  # @!attribute [r] name
  #
  # @return [Symbol,String] configuration name.
  #
  attr_reader :name

  ################
  #  write_name  #
  ################

  ###
  # Configuration write accessor.
  #
  # @!attribute [r] write_name
  #
  # @return [Symbol,String] configuration write name.
  #
  attr_reader :write_name

  ############
  #  module  #
  ############
  
  ###
  # Configuration module for which configuration exists.
  #
  # @!attribute [r] module
  #
  # @return [CascadingConfiguration::Module] Configuration module.
  #
  attr_reader :module

  #######################
  #  extension_modules  #
  #######################

  ###
  # Extension modules associated with configuration.
  #
  # @!attribute [r] extension_modules
  #
  # @return [Array::Unique] Extension modules.
  #
  attr_reader :extension_modules

  ################
  #  has_value?  #
  ################

  ###
  # Query whether instance has a value set for configuration.
  #
  # @return [ true, false ]
  #
  #         Whether configuration name has value for instance.
  #
  def has_value?

    return @has_value

  end
  
  ############
  #  value   #
  ############
  
  ###
  # Get configuration value for configuration name for instance.
  #
  # @return [::Object]
  #
  #         Configuration value.
  #
  def value
    
    return @value

  end

  ############
  #  value=  #
  ############

  ###
  # Set configuration value.
  #
  # @param [Object]
  #
  #        object
  #
  #        Value of configuration.
  #
  def value=( object )
    
    @has_value = true
    @value = object
    
  end

  ##################
  #  clear  #
  ##################
  
  ###
  # Unset value for configuration.
  #
  # @return Self.
  #
  def clear
    
    @has_value = false
    @value = nil
        
    return self

  end

end
