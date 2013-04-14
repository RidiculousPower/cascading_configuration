# -*- encoding : utf-8 -*-

###
# Configurations extended for Compositing Objects.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration < 
      ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration
  
  ##############################################
  #  self.new_inheriting_object_configuration  #
  ##############################################
  
  def self.new_inheriting_object_configuration( for_instance, parent_configuration, event = nil, & block )
    
    instance = parent_configuration.new_configuration_without_parent( for_instance, event, & block )
    parent_configuration.parents.each { |this_parent| instance.register_parent( this_parent ) }
    
    return instance

  end
  
  ###############################
  #  initialize«common_values»  #
  ###############################
  
  def initialize«common_values»( for_instance, *parsed_args, & block )
    
    super

    @parents = ::Array::Unique.new( self )
    @value = @module.compositing_object_class.new( nil, for_instance )
        
  end

  #################################
  #  initialize«common_finalize»  #
  #################################
  
  def initialize«common_finalize»( for_instance, *parsed_args, & block )

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
      super( this_parent )
      @parents.push( this_parent )
      register_composite_object_parent( this_parent.compositing_object )
    end
    
    # we don't use @parent anymore, @parents instead
    @parent = nil

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
  def register_parent_for_ruby_hierarchy( *parents )

    parents.each { |this_parent| super( this_parent ) }
    @value.extend( *@extension_modules ) unless @extension_modules.empty?
    
    return self
    
  end

  #######################################
  #  register_parent_extension_modules  #
  #######################################
  
  def register_parent_extension_modules( parent )

    super
    
    @value.extend( *@extension_modules ) unless @extension_modules.empty?
    
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
    
    return @parents.empty? ? false : true
    
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
    
    potential_parent = configuration_for_configuration_or_instance( potential_parent )

    return @parents.include?( potential_parent ) ||
           @parents.any? { |this_parent| this_parent.is_parent?( potential_parent ) }
    
  end

  ##########################
  #  is_immediate_parent?  #
  ##########################
  
  ###
  # Query whether potential parent instance is an immediate parent for configuration in instance.
  #
  # @param potential_parent
  #
  #        Potential parent instance being queried.
  #
  # @return [ true, false ]
  #
  #         Whether potential parent instance is parent for configuration name.
  #
  def is_immediate_parent?( potential_parent )
    
    potential_parent = configuration_for_configuration_or_instance( potential_parent )

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
