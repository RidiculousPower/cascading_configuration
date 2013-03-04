# -*- encoding : utf-8 -*-

###
# Configurations for cascading variables.
#
class ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues::Configuration < 
      ::CascadingConfiguration::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  ###
  # @overload new( instance, configuration_module, configuration_name, write_accessor_name = configuration_name, 
  #                & cascade_block )
  #
  # @overload new( instance, parent_configuration )
  #
  def initialize( instance, *args, & cascade_block )

    super( instance, *args )
    
    unless @parent or block_given?
      raise ::ArgumentError, 'Block required to produce cascade value.'
    end

    @cascade_block = cascade_block || @parent.cascade_block
        
    @parent.register_child( self ) if @parent
    @has_value = false

    initialize_for_instance
        
  end
  
  ###################
  #  cascade_block  #
  ###################
  
  attr_reader :cascade_block
  
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

  ##############
  #  children  #
  ##############
  
  attr_reader :children
  
  ####################
  #  register_child  #
  ####################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #
  # @param child
  #
  #        Child instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_child( child, register_parent = true )
    
    @children ||= ::Array::Unique.new( self )
    unless is_child?( child )
      child.register_parent( self ) if register_parent
      @children.push( child )
      cascade_value_to_child( child ) if @value
    end
    
    return self
    
  end

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
  attr_accessor :parent
  
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
    
    @parent.unregister_child( self ) if @parent
    @parent = parent
    @parent.register_child( self, false )
    
    return self
    
  end
  
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
    
    @parent.unregister_child( self ) if @parent
    @parent = new_parent

    return self
    
  end

  ######################
  #  unregister_child  #
  ######################

  def unregister_child( child, unregister_parent = true )
    
    @children.delete( child ) if @children
    
    child.unregister_parent( self ) if unregister_parent
    
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
    
    @parent.unregister_child( self, false )
    @parent = nil

    return self
  
  end
  
  ###################
  #  has_children?  #
  ###################

  def has_children?

    return @children ? ! @children.empty? : false
    
  end
  
  #################
  #  has_parent?  #
  #################

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
  def has_parent?
    
    return @parent ? true : false
    
  end

  ###############
  #  is_child?  #
  ###############

  def is_child?( potential_child )
    
    return @children ? @children.any? { |this_child| this_child.equal?( potential_child ) || 
                                                     this_child.is_child?( potential_child ) }
                     : false
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
    
    return  @parent ? @parent.equal?( potential_parent ) || @parent.is_parent?( potential_parent ) 
                    : false
    
  end

  ############
  #  value=  #
  ############

  ###
  # Set configuration value.
  #
  # @param [ Object ]
  #
  #        object
  #
  #        Value of configuration.
  #
  def value=( object )
    
    super
    
    cascade_value
    
  end
  
  ###################
  #  cascade_value  #
  ###################

  def cascade_value
    
    @children.each { |this_child| cascade_value_to_child( this_child ) } if @children
    
  end

  ############################
  #  cascade_value_to_child  #
  ############################

  def cascade_value_to_child( child )
    
    child.value = child.instance_exec( @value, self, & child.cascade_block )
    
    return self
    
  end
  
end
