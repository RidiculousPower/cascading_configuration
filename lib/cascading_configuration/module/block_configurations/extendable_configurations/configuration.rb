# -*- encoding : utf-8 -*-

###
# Configurations extended for Compositing Objects.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration < 
      ::CascadingConfiguration::Module::Configuration
  
  #######################
  #  initialize_common  #
  #######################
  
  def initialize_common( instance )

    super
    
    @extension_modules = ::Array::Compositing::Unique.new( nil, self )        
    
  end
  
  ###############################
  #  declare_extension_modules  #
  ###############################
  
  def declare_extension_modules( *extension_modules )
    
    unless extension_modules.empty?
      @extension_modules.unshift( *extension_modules )
      @value.extend( *extension_modules )
    end
    
    return self
    
  end
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  ###
  # Query whether configuration permits multiple parents.
  #
  # @return [true]
  #
  #         Whether multiple parents are permitted.
  #
  def permits_multiple_parents?
    
    return false
    
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
  #
  # @overload register_parent( parent )
  #
  #   @param parent
  #   
  #          Parent instance from which configurations are being inherited.
  #
  #   @yield [ parent ]
  #
  #          Block to perorm additional actions related to the Ruby ancestor hierarchy,
  #          which will not be performed for explicit calls to #register_parent.
  #
  #   @yieldparam parent
  #
  #               Parent being registered.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( parent, & block )
    
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

    yield( parent ) if block_given?
    
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

    return register_parent( parent ) { |this_parent| register_parent_extension_modules( this_parent ) }
    
  end

  #######################################
  #  register_parent_extension_modules  #
  #######################################
  
  def register_parent_extension_modules( parent )

    @extension_modules.register_parent( parent.extension_modules )

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
  # @param [ Object ]
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
