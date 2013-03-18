
class ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  ###################
  #  post_set_hook  #
  ###################
  
  def post_set_hook( key, configuration )

    @controller.active_configurations( configuration_instance )[ key ] = configuration
    
    return configuration
    
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
    
    return parent_configuration.class.new_inheriting_instance( configuration_instance, parent_configuration, @event )

  end
  
end
