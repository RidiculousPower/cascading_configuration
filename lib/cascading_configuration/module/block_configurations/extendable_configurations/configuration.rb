# -*- encoding : utf-8 -*-

###
# Configurations extended for Compositing Objects.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration < 
      ::CascadingConfiguration::Module::BlockConfigurations::Configuration
  
  ###############################
  #  initialize«common_values»  #
  ###############################
  
  def initialize«common_values»( for_instance, *extension_modules, & block )
    
    super

    initialize«extension_modules»( *extension_modules, & block )
        
  end
  
  ###################################
  #  initialize«extension_modules»  #
  ###################################
  
  def initialize«extension_modules»( *extension_modules, & block )

    @extension_modules = ::Array::Compositing::Unique.new( nil, self )
    if block_given?
      if @extension_module
        @extension_module.module_eval( & block )
      else
        create_extension_module( @name, & block )
      end
    end
    @extension_modules.concat( *extension_modules )
    
    return self
    
  end

  #######################################
  #  new«configuration_without_parent»  #
  #######################################

  def new«configuration_without_parent»( for_instance, event = nil, & block )

    new_configuration = self.class.new( for_instance, @module, @name, @write_name, & block )
    
    # concat b/c we don't want parent relation but we do want a copy with same functionality
    new_configuration.extension_modules.concat( @extension_modules ) if @extension_modules

    return new_configuration

  end
    
  #############################
  #  create_extension_module  #
  #############################

  def create_extension_module( name, & block )

    @extension_module = self.class::ExtensionModule.new( self, name, & block )
    @extension_modules.unshift( @extension_module )
    if ::Module === @instance
      constant_name = 'ExtensionModule«' << name.to_s << '»'
      @instance.const_set( constant_name, @extension_module )
    end

    return @extension_module

  end
    
  #######################################
  #  register_parent_extension_modules  #
  #######################################
  
  def register_parent_extension_modules( parent )

    @extension_modules.register_parent( parent.extension_modules )
    
    return self

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

  ##############################
  #  register_inactive_parent  #
  ##############################
  
  ###
  # Register configuration for inactive parent instance, which means that singleton parent does not exist.
  #   Registers extension modules from inactive parent.
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

    parent = configuration_for_configuration_or_instance( parent )
    
    register_parent_extension_modules( parent )
    
    return self
    
  end

  #####################
  #  register_parent  #
  #####################

  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #
  # @overload register_parent( parent )
  #
  #   @param parent
  #   
  #          Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( parent )
    
    parent = configuration_for_configuration_or_instance( parent )

    # is the new parent already part of the parent chain?
    unless is_parent?( parent )
      # avoid cyclic references
      if parent.is_parent?( self )
        raise ::ArgumentError, 'Registering instance ' << parent.instance.to_s + ' as parent of instance ' <<
                               @instance.to_s << ' would cause cyclic reference.'
      end
    end
    
    @parent = parent

    return self
    
  end

  #################################################
  #  register_inactive_parent_for_ruby_hierarchy  #
  #################################################
  
  ###
  # Register configuration for inactive parent instance, which means that singleton parent does not exist.
  #   Registers extension modules from inactive parent.
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
    
    parent = configuration_for_configuration_or_instance( parent )
    
    register_parent_extension_modules( parent )
    
    return self
    
  end
  
  ########################################
  #  register_parent_for_ruby_hierarchy  #
  ########################################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration when registration
  #   is performed in the context of Ruby inheritance.
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
  def register_parent_for_ruby_hierarchy( parent )
    
    parent = configuration_for_configuration_or_instance( parent )
    
    register_parent( parent )
    register_parent_extension_modules( parent )
    
    return self
    
  end
  
  #######################
  #  unregister_parent  #
  #######################

  ###
  # Remove a current parent for configuration instance.
  #
  # @param existing_parent
  #
  #        Current parent instance to replace.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def unregister_parent( existing_parent )
    
    existing_parent = configuration_for_configuration_or_instance( existing_parent )
    @parent = nil if @parent.equal?( existing_parent )
    
    return self
  
  end

  ##################
  #  has_parents?  #
  ##################

  ###
  # Query whether one or more parents exist.
  #   Used in context where only one parent is permitted.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param [Symbol,String]
  #
  #        configuration_name
  #
  #        Name of configuration.
  #
  # @return [ true, false ]
  #
  #         Whether parent exists for configuration.
  #
  def has_parents?
    
    return @parent ? true : false
    
  end
  
  ################
  #  is_parent?  #
  ################
  
  ###
  # Query whether potential parent instance is a parent for configuration in instance.
  #
  # @param potential_parent
  #
  #        Potential parent instance being queried.
  #
  # @return [ true, false ]
  #
  #         Whether potential parent instance is parent for configuration name.
  #
  def is_parent?( potential_parent )
    
    is_parent = false
    
    potential_parent = configuration_for_configuration_or_instance( potential_parent )

    if @parent.equal?( potential_parent ) or
       @parent && @parent.is_parent?( potential_parent )
      is_parent = true
    end
    
    return is_parent
    
  end

end
