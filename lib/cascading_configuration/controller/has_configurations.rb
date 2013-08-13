# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::HasConfigurations

  #########################
  #  has_configurations?  #
  #########################
  
  ###
  # Query whether any configurations exist for instance.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ true, false ] 
  #
  #         Whether configurations exist for instance.
  #
  def has_configurations?( instance )
    
    return ! active_configurations( instance ).empty?
    
  end

  ########################
  #  has_configuration?  #
  ########################

  ###
  # Query whether configuration has been registered for instance.
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
  #         Whether configuration has been registered for instance.
  #
  def has_configuration?( instance, configuration_name )

    return active_configurations( instance ).has_key?( configuration_name.to_sym )

  end

  ###################################
  #  has_singleton_configurations?  #
  ###################################

  def has_singleton_configurations?( instance )
    
    return singleton_configurations( instance, false ) ? true : false
    
  end

  ##################################
  #  has_instance_configurations?  #
  ##################################
  
  def has_instance_configurations?( instance )

    return instance_configurations( instance, false ) ? true : false

  end
  
  ################################
  #  has_object_configurations?  #
  ################################

  def has_object_configurations?( instance )

    return object_configurations( instance, false ) ? true : false

  end

  ########################################
  #  has_local_instance_configurations?  #
  ########################################
  
  def has_local_instance_configurations?( instance )

    return local_instance_configurations( instance, false ) ? true : false

  end

  ########################
  #  has_configuration?  #
  ########################

  def has_configuration?( instance, configuration_name, ensure_exists = false )

    return configuration( instance, configuration_name, ensure_exists ) ? true : false

  end

  ##################################
  #  has_singleton_configuration?  #
  ##################################

  def has_singleton_configuration?( instance, configuration_name, ensure_exists = false )
    
    return singleton_configuration( instance, configuration_name, ensure_exists ) ? true : false
    
  end

  #################################
  #  has_instance_configuration?  #
  #################################
  
  def has_instance_configuration?( instance, configuration_name, ensure_exists = false )

    return instance_configuration( instance, configuration_name, ensure_exists ) ? true : false

  end
  
  ###############################
  #  has_object_configuration?  #
  ###############################

  def has_object_configuration?( instance, configuration_name, ensure_exists = false )

    return object_configuration( instance, configuration_name, ensure_exists ) ? true : false

  end

  #######################################
  #  has_local_instance_configuration?  #
  #######################################
  
  def has_local_instance_configuration?( instance, configuration_name, ensure_exists = false )

    return local_instance_configuration( instance, configuration_name, ensure_exists ) ? true : false

  end

end
