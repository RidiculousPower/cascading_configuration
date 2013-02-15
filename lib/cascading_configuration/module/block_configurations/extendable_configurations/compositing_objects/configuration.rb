
###
# Configurations extended for Compositing Objects.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration < 
      ::CascadingConfiguration::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  ###
  # @overload new( instance, configuration_module, configuration_name, write_accessor_name = configuration_name )
  #
  # @overload new( instance, parent_configuration, ... )
  #
  def initialize( instance, *args )

    parents = nil
    
    case args[ 0 ]
      when self.class
        # we assume all parent configuration instances provided have matching module/name, so use the first to configure
        super( instance, args[ 0 ] )
        # but we can have more than one parent, so we need to register the rest
        parents = args        
      else
        super( instance, *args )
    end
    
    @value = @module.compositing_object_class.new( nil, instance )
    
    @parents = ::Array::Unique.new( self )
    @extension_modules = ::Array::Compositing::Unique.new( nil, self )        
    register_parent( *parents ) if parents
    
    # registering parent might have filled in extension modules
    @value.extend( *@extension_modules ) unless @extension_modules.empty?
    
  end

  ########################
  #  compositing_object  #
  ########################
  
  alias_method :compositing_object, :value
  
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
    
    return true
    
  end

  #############
  #  parents  #
  #############

  ###
  # Get parents for configuration name on instance.
  #   Used in context where multiple parents are permitted.
  #
  # @return [Array<::Object>]
  #
  #         Parent instances registered for configuration.
  #
  attr_reader :parents

  #####################
  #  register_parent  #
  #####################

  ###
  # Register configuration for instance with parent instance as parent for configuration.
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
  def register_parent( *parents )

    parents.each do |this_parent|

      case this_parent
        when ::CascadingConfiguration::Module::Configuration
          # parent is what we want already
        else
          if ::CascadingConfiguration.has_configuration?( this_parent, @name )
            this_parent = ::CascadingConfiguration.configuration( this_parent, @name )
          else
            next
          end
      end

      # is the new parent already part of the parent chain?
      unless is_parent?( this_parent )
        if this_parent.is_parent?( self )
          raise ::ArgumentError, 'Registering instance ' << parent.instance.to_s + ' as parent of instance ' <<
                                 @instance.to_s << ' would cause cyclic reference.'
        end
        # if not, register it
        @parents.push( this_parent )
        parent_extension_modules = this_parent.extension_modules
        @extension_modules.register_parent( parent_extension_modules )
        unless parent_extension_modules.empty?
          @value.extend( *parent_extension_modules )
        end
        register_composite_object_parent( this_parent.compositing_object )
      end

    end

    return self

  end

  ######################################
  #  register_composite_object_parent  #
  ######################################
  
  ###
  # Register a composite object instance as the parent of the instance associated with this configuration.
  #
  # @param parent_composite_object [Array::Compositing,Hash::Compositing]
  #
  #        Parent composite object instance.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def register_composite_object_parent( parent_composite_object )
  
    @value.register_parent( parent_composite_object )
  
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
    
    case existing_parent
      when ::CascadingConfiguration::Module::Configuration
        # parent is what we want already
      else
        if ::CascadingConfiguration.has_configuration?( existing_parent, @name )
          existing_parent = ::CascadingConfiguration.configuration( existing_parent, @name )
        else
          existing_parent = nil
        end
    end

    if existing_parent
      @value.unregister_parent( existing_parent.compositing_object )
      @parents.delete( existing_parent )
    end
    
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
    
    return @value.has_parents?
    
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
    
    case potential_parent
      when ::CascadingConfiguration::Module::Configuration
        # parent is what we want already
      else
        potential_parent = ::CascadingConfiguration.configuration( potential_parent, @name )
    end
    
    return @parents.include?( potential_parent )
    
  end

  ##########################
  #  match_lowest_parents  #
  ##########################
  
  ###
  # Match lowest parents for configuration for which block returns true.
  #   Used in context where multiple parents are permitted.
  #
  # @yield match_block
  #
  #        Block to determine match.
  #
  # @yieldparam parent
  #
  #             Parent block is testing against.
  #
  # @return [Array<::Object>]
  #
  #         Parent that matched.
  #
  def match_lowest_parents( & match_block )
  
    # we use a unique array because diamond shaped inheritance gives the same parent twice
    lowest_parents = ::Array::Unique.new
    
    @parents.each do |this_parent_configuration|

      # if we match this parent we are done with this branch and can go to the next
      if match_block.call( this_parent_configuration )

        lowest_parents.push( this_parent_configuration )

      # otherwise our branch expands and we have to finish it before the next parent
      elsif this_parent_configuration.has_parents?

        parents_for_branch = this_parent_configuration.match_lowest_parents( & match_block )
        lowest_parents.concat( parents_for_branch )

      end

    end
  
    return lowest_parents
    
  end

  ############
  #  value=  #
  ############
  
  ###
  # Replace existing configuration object values with values provided.
  #
  # @param value [Array,Hash]
  #
  #        An object corresponding to compositing object class, 
  #        but which does not have to be a compositing object.
  #
  # @return [Array::Compositing,Hash::Compositing]
  #
  #         Compositing Object.
  #
  def value=( value )

    return @value.replace( value )
    
  end
  
end
