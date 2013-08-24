# -*- encoding : utf-8 -*-

###
# Configurations for inheriting values.
#
class ::CascadingConfiguration::Module::CascadingSettings::Configuration < 
      ::CascadingConfiguration::Module::Configuration

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
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
        
    # if we have an existing parent we need to know:
    #
    # * is it the parent we're registering? => keep, no change
    # * is it a child of the parent we're registering? => keep, no change
    # * is it a parent of the parent we're registering? => replace with parent
    # * otherwise => set parent 
    #
    # :is_parent? will answer all of these questions, checking up the chain
    
    # if we have a configuration we use it as parent
    # otherwise we look up configuration for parent
    controller = @module.controller
    unless ::CascadingConfiguration::Module::Configuration === parent
      if controller.has_configuration?( parent, @name )
        parent = controller.configuration( parent, @name )
      else
        parent = nil
      end
    end

    unless parent.nil? or @parent && is_parent?( parent )
      
      if parent.is_parent?( self )
        raise ::ArgumentError, 'Registering instance ' << parent.instance.to_s + ' as parent of instance ' <<
                               @instance.to_s << ' would cause cyclic reference.'
      end
      
      @parent = parent

    end
    
    return self
    
  end

  ########################################
  #  register_parent_for_ruby_hierarchy  #
  ########################################
  
  alias_method :register_parent_for_ruby_hierarchy, :register_parent

  ############
  #  parent  #
  ############
  
  ###
  # Get parent for configuration name on instance.
  #   Used in context where only one parent is permitted.
  #
  # @!attribute [r] parent
  #
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  attr_reader :parent

  ####################
  #  replace_parent  #
  ####################

  ###
  # Replace parent for configuration instance with a different parent.
  #
  # @overload replace_parent( new_parent )
  #
  #   @param new_parent
  #   
  #          New parent instance.
  #
  # @overload replace_parent( existing_parent, new_parent )
  #
  #   @param existing_parent
  #   
  #          Existing parent instance (ignored).
  #
  #   @param new_parent
  #   
  #          New parent instance.
  #
  # @return [self]
  #
  #         Self.
  #
  def replace_parent( *args )
    
    new_parent = nil
    existing_parent = nil
    
    case args.size
      when 1
        new_parent = args[ 0 ]
      when 2
        # existing_parent = args[ 0 ]
        new_parent = args[ 1 ]
    end
  
    unregister_parent
    register_parent( new_parent )

    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################

  ###
  # Remove parent for configuration instance .
  #
  # @return [self]
  #
  #         Self.
  #
  def unregister_parent( *args )
    
    @parent = nil

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

  ################################
  #  match_parent_configuration  #
  ################################
  
  ###
  # Match first parent for which block returns true.
  #
  # @yield match_block
  #
  #        Block to determine match.
  #
  # @yieldparam parent
  #
  #             Parent block is testing against.
  #
  # @return [nil,::Object]
  #
  #         Parent that matched.
  #
  def match_parent_configuration( & match_block )
   
    matched_parent = nil
    
    this_parent = self

    begin
      if match_block.call( this_parent )
        matched_parent = this_parent
        break
      end
    end while this_parent = this_parent.parent

    return matched_parent
    
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
    
    potential_parent_configuration = nil
    
    controller = @module.controller
    case potential_parent
      when ::CascadingConfiguration::Module::Configuration
        potential_parent_configuration = potential_parent
      else
        potential_parent_configuration = controller.configuration( potential_parent, @name )
    end

    return match_parent_configuration do |this_parent_configuration|
      this_parent_configuration.equal?( potential_parent_configuration )
    end ? true : false
    
  end

  #################
  #  local_value  #
  #################
  
  alias_method :local_value, :value
  
  ###########
  #  value  #
  ###########

  ###
  # Value of configuration.
  #
  # @return [Object] Configuration value.
  #
  def value

    configuration_value = nil
        
    matching_parent = match_parent_configuration do |this_parent_configuration|
      this_parent_configuration.has_value? ? true: false
    end

    if matching_parent
      configuration_value = matching_parent.local_value
    end
    
    return configuration_value
    
  end
  
end
