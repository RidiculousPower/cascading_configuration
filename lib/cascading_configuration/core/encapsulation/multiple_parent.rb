
class ::CascadingConfiguration::Core::Encapsulation::MultipleParents < ::CascadingConfiguration::Core::Encapsulation

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

    unless parents_array = parents_hash[ configuration_name ]
      parents_hash[ configuration_name ] = parents_array = [ ]
    end
    
    parent_registered = false
    
    # if we have existing parents we need to know:
    parents_array.each_with_index do |this_parent, this_index|
      
      # * are they the parent we're registering? => keep, no insert
      # * are they children of the parent we're registering? => keep, no insert
      if this_parent.equal?( parent )  or
         is_parent_for_configuration?( this_parent, configuration_name, parent )
        
        # nothing to do
        parent_registered = true
        break
        
      # * are they parents of the parent we're registering? => replace with new parent
      elsif is_parent_for_configuration?( this_parent, configuration_name, parent )
      
        parents_array[ this_index ] = parent
        parent_registered = true
        break
      
      end
      
    end

    # * otherwise => add
    unless parent_registered
      parents_array.unshift( parent )
    end

    
    return self
    
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

  ###############################
  #  parents_for_configuration  #
  ###############################

  ###
  # Get parents for configuration name on instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [Array<::Object>]
  #
  #         Parent instances registered for configuration.
  #
  def parents_for_configuration( instance, configuration_name )
    
    unless instance.equal?( ::Class )
      
      parents_hash = parents_for_configuration_hash( instance )
      
      unless parents = parents_hash[ configuration_name ]
        parents_hash[ configuration_name ] = parents = [ ]
      end

      instance_class = instance.class
      if has_configuration?( instance_class, configuration_name )
        parents.push( instance_class )
      end

    end

    return parents
    
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
      
      has_parent_for_configuration = ! parent_or_parents.empty?
      
    end
    
    return has_parent_for_configuration
    
  end

  ############################################
  #  match_lowest_parents_for_configuration  #
  ############################################
  
  ###
  # Match lowest parents for configuration for which block returns true.
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
  # @return [nil,Array<::Object>]
  #
  #         Parent that matched.
  #
  def match_lowest_parents_for_configuration( instance, configuration_name, & match_block )
  
    # we use a unique array because diamond shaped inheritance gives the same parent twice
    lowest_parents = ::Array::Unique.new
    
    parents_for_configuration( instance, configuration_name ).each do |this_parent|

      # if we match this parent we are done with this branch and can go to the next
      if match_block.call( this_parent )

        lowest_parents.push( this_parent )

      # otherwise our branch expands and we have to finish it before the next parent
      elsif has_parent_for_configuration?( this_parent, configuration_name )

        parents_for_branch = match_lowest_parents_for_configuration( this_parent, configuration_name, & match_block )

        lowest_parents.concat( parents_for_branch )

      end

    end
  
    return lowest_parents
    
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

end
