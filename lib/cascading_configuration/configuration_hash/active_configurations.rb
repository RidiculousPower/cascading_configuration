# -*- encoding : utf-8 -*-

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

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    child_configuration = nil
    
    if ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations === parent_configurations and
       singleton_configuration = @controller.local_instance_configuration( parent_configuration.parent.instance, 
                                                                           configuration_name, 
                                                                           false )
      child_configuration = singleton_configuration.new_inheriting_configuration( configuration_instance, @event )
    else
      child_configuration = parent_configuration.new_inheriting_configuration( configuration_instance, @event )
    end
    
    return child_configuration

  end
  
end
