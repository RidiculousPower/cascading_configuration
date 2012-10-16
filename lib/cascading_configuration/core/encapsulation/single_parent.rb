
class ::CascadingConfiguration::Core::Encapsulation::SingleParent < ::CascadingConfiguration::Core::Encapsulation

  #######################################
  #  register_parent_for_configuration  #
  #######################################
  
  def register_parent_for_configuration( instance, configuration_name, parent )
    
    parents_for_configuration = parents_for_configuration( instance, configuration_name )
    
    parents_for_configuration.unshift( parent )
    
  end

  #######################################
  #  register_parent_for_configuration  #
  #######################################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #
  # @param child
  #
  #        Child instance for which configurations are being registered.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent_for_configuration( child, parent, configuration_name )
        
    parents_hash = parents_for_configuration_hash( child )
    
    # if we have an existing parent we need to know:
    # * is it the parent we're registering? => keep, no change
    # * is it a child of the parent we're registering? => keep, no change
    unless existing_parent = parents_hash[ configuration_name ] and
           existing_parent.equal?( parent )  ||
           is_parent_for_configuration?( existing_parent, configuration_name, parent )
    
      # * is it a parent of the parent we're registering? => replace with parent
      # * otherwise => set parent 
      parents_hash[ configuration_name ] = parent
    
    end
    
    return self
    
  end

  ##############################
  #  parent_for_configuration  #
  ##############################
  
  ###
  # Get parent for configuration name on instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  def parent_for_configuration( instance, configuration_name )
    
    parent = nil
    
    unless instance.equal?( ::Class )
      
      unless parent = parents_for_configuration_hash( instance )[ configuration_name ]
        instance_class = instance.class
        if has_configuration?( instance_class, configuration_name )
          parent = instance_class
        end
      end
          
    end
    
    return parent

  end

  ###############################
  #  parents_for_configuration  #
  ###############################
  
  def parents_for_configuration( instance, configuration_name )
    
    parents = nil
    
    parents_for_configuration_hash = parents_for_configuration_hash( instance )
    
    unless parents = parents_for_configuration_hash[ configuration_name ]
      parents_for_configuration_hash[ configuration_name ] = parents = ::Array::Compositing::Unique.new
    end
    
    return parents
    
  end

  ##################################
  #  is_parent_for_configuration?  #
  ##################################
  
  ###
  # Query whether potential parent instance is a parent for configuration in instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration being queried.
  #
  # @param potential_parent
  #
  #        Potential parent instance being queried.
  #
  # @return [true,false]
  #
  #         Whether potential parent instance is parent for configuration name.
  #
  def is_parent_for_configuration?( instance, configuration_name, potential_parent )
    
    is_parent_for_configuration = false
    
    matched_parent = match_parent_for_configuration( instance, configuration_name ) do |this_parent|
      this_parent.equal?( potential_parent )
    end
    
    if matched_parent
      is_parent_for_configuration = true  
    end
    
    return is_parent_for_configuration
    
  end

  ###################################
  #  has_parent_for_configuration?  #
  ###################################

  ###
  # Query whether one or more parents exist.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [true,false]
  #
  #         Whether parent exists for configuration.
  #
  def has_parent_for_configuration?( instance, configuration_name )
    
    has_parent_for_configuration = false
    
    if parent_or_parents = parents_for_configuration_hash( instance )[ configuration_name ]
      
      has_parent_for_configuration = true
       
    end
    
    return has_parent_for_configuration
    
  end

  ####################################
  #  match_parent_for_configuration  #
  ####################################
  
  ###
  # Match first parent for which block returns true.
  #   Used in context where only one parent is permitted.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
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
  def match_parent_for_configuration( instance, configuration_name, & match_block )
   
    matched_parent = nil
    
    this_parent = instance

    begin

      if match_block.call( this_parent )
        matched_parent = this_parent
        break
      end

    end while this_parent = parent_for_configuration( this_parent, configuration_name )

    return matched_parent
    
  end

end
