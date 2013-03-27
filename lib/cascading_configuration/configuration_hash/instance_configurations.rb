# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations

  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )

    # we want instance configuration details such as extension modules

    # but inheritance relations need to map to the singleton configuration if it exists
    case parent_configurations
      when ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations
        child_configuration = parent_configuration.new_inheriting_object_configuration( configuration_instance, @event )
        singleton_configuration = @controller.singleton_configuration( parent_configuration.parent.instance, 
                                                                       configuration_name, 
                                                                       false )
        child_configuration.register_parent( singleton_configuration )
      else
        child_configuration = super
    end
    
    return child_configuration

  end
  
end
