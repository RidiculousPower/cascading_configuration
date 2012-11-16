
###
# Configurations for inheriting values.
#
class ::CascadingConfiguration::Core::Module::InheritingValues::Configuration < 
      ::CascadingConfiguration::Core::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  ###
  # @overload new( instance, configuration_module, configuration_name, write_accessor_name = configuration_name )
  #
  # @overload new( instance, ancestor_configuration )
  #
  def initialize( instance, *args )

    case args[ 0 ]
      
      when self.class
        
        parent_instance = args[ 0 ]
        
        super( instance, parent_instance.module, parent_instance.name, parent_instance.write_name )

        register_parent( parent_instance )
        
      else

        super( instance, *args )

    end

    @has_value = false
    
    initialize_for_instance
    
  end
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  def permits_multiple_parents?
    
    return false
    
  end

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
    
    unless @parent and is_parent?( parent )
      @parent = parent
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
  # @!attribute [r]
  #
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  attr_reader :parent

  ####################
  #  replace_parent  #
  ####################

  def replace_parent( new_parent )
  
    @parent = new_parent

    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################

  def unregister_parent
    
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
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param [ Symbol, String ]
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
    
    return match_parent do |this_parent|
      this_parent.equal?( potential_parent )
    end ? true : false
    
  end
  
  ##################
  #  match_parent  #
  ##################
  
  ###
  # Match first parent for which block returns true.
  #   Used in context where only one parent is permitted.
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
  def match_parent( & match_block )
   
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

  #################
  #  local_value  #
  #################
  
  alias_method :local_value, :value
  
  ###########
  #  value  #
  ###########

  def value

    configuration_value = nil

    matching_parent = match_parent do |this_parent|
      if this_parent.has_value?
        true
      else
        false
      end
    end

    if matching_parent
      configuration_value = matching_parent.local_value
    end
    
    return configuration_value
    
  end
  
end
