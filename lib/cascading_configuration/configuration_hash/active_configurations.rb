
class ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_hash, parent_configuration_name )
    
    if has_key?( parent_configuration_name )
      # if we already have a configuration then we want to register the parent as its parent
      # then we are done with lookup
      parent_configuration = parent_hash[ parent_configuration_name ]
      child_configuration = self[ parent_configuration_name ]
      child_configuration.register_parent( parent_configuration )
    else
      super
    end

    return self
    
  end

  ###################
  #  post_set_hook  #
  ###################
  
  def post_set_hook( key, configuration )

    @controller.active_configurations( configuration_instance )[ key ] = configuration
    
    return configuration_instance
    
  end

  ######################
  #  post_delete_hook  #
  ######################
  
  def post_delete_hook( key, configuration )
    
    @controller.active_configurations( configuration_instance ).delete( key )
    
    return configuration
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_hash )

    return ::CascadingConfiguration::InactiveConfiguration === parent_configuration ?
               parent_configuration.new_active_instance( configuration_instance, @event )
             : parent_configuration.class.new_inheriting_instance( configuration_instance, 
                                                                   parent_configuration,
                                                                   @event )

  end

end
