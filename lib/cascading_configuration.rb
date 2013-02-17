
begin ; require 'development' ; rescue ::LoadError ; end

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

module ::CascadingConfiguration
  
  extend ::ParallelAncestry
  
  @configurations = { }
  
  ###################
  #  self.included  #
  ###################
  
  ###
  # Include causes all defined cascading configuration modules to be included.
  #
  def self.included( instance )
    
    super if defined?( super )
    
    configuration_modules = ::CascadingConfiguration.configuration_modules
    instance.module_eval { configuration_modules.each { |this_member| include( this_member ) } }
    
  end

  ###################
  #  self.extended  #
  ###################
  
  ###
  # Extend causes all defined cascading configuration modules to be extended.
  #
  def self.extended( instance )
    
    super if defined?( super )
    
    ::CascadingConfiguration.configuration_modules.each { |this_member| instance.extend( this_member ) }
    
  end

  #####################################
  #  self.create_instance_controller  #
  #####################################
  
  def self.create_instance_controller( instance, extending = false )
    
    return ::CascadingConfiguration::InstanceController.create_instance_controller( instance, extending )
    
  end
  
  ##############################
  #  self.instance_controller  #
  ##############################
  
  def self.instance_controller( instance, ensure_exists = false )
    
    return ::CascadingConfiguration::InstanceController.instance_controller( instance, ensure_exists )
    
  end
  
  #########################
  #  self.configurations  #
  #########################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [Object] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [CascadingConfiguration::ConfigurationHash{Symbol,String => CascadingConfiguration::Module}]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def self.configurations( instance )
    
    configurations_hash = nil
    
    unless configurations_hash = @configurations[ instance_id = instance.__id__ ]
      configurations_hash = ::CascadingConfiguration::ConfigurationHash.new( nil, instance )
      @configurations[ instance_id ] = configurations_hash
      unless instance.equal?( ::Class )
        register_parent( instance, instance.class )
      end
    end
    
    return configurations_hash

  end

  ###############################
  #  self.define_configuration  #
  ###############################
  
  ###
  # Define configuration for instance.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param [ CascadingConfiguration::Module::Configuration ]
  #
  #        configuration_instance
  #        
  #        Hash of configuration names pointing to corresponding configuration instances.
  # 
  # @return Self.
  #
  def self.define_configuration( instance, configuration )
    
    configurations( instance )[ configuration.name ] = configuration
    
    return self
    
  end

  ########################
  #  self.configuration  #
  ########################
  
  ###
  # Get configuration for instance. Creates configuration for instance if does not already exist for instance
  #   but does exist for instance's class.
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
  #        Configuration name to retrieve.
  #
  # @return [ CascadingConfiguration::Module::Configuration ]
  #
  #         Configuration instance for name on instance.
  #
  def self.configuration( instance, configuration_name )
    
    unless configuration_instance = configurations( instance )[ configuration_name.to_sym ]
      raise ::ArgumentError, 'No configuration ' << configuration_name.to_s + ' for ' << instance.to_s + '.'
    end
    
    return configuration_instance
    
  end
  
  ##########################
  #  self.register_parent  #
  ##########################
  
  ###
  # Runs #register_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be registered.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be registered for instance.
  #
  # @return self.
  #
  def self.register_parent( instance, parent, include_extend_subclass_instance = nil )
    
    super( instance, parent )

    configurations( instance ).register_parent( configurations( parent ), include_extend_subclass_instance )
          
    return self
    
  end
  
  ############################
  #  self.unregister_parent  #
  ############################
  
  ###
  # Runs #unregister_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be unregistered.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be unregistered for instance.
  #
  # @return self.
  #
  def self.unregister_parent( instance, parent )
    
    super
    
    configurations( instance ).unregister_parent( configurations( parent ) )
        
    return self
    
  end

  #########################
  #  self.replace_parent  #
  #########################
  
  ###
  # Runs #replace_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be replaceed.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be replaced for instance.
  #
  # @param [ Object ]
  #
  #        new_parent
  #
  #        Parent to replace old parent.
  #
  # @return Self.
  #
  def self.replace_parent( instance, parent, new_parent )
    
    configurations( instance ).replace_parent( configurations( parent ) )
    
    return self
    
  end

  ##############################
  #  self.has_configurations?  #
  ##############################
  
  ###
  # Query whether any configurations exist for instance.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ true, false ] 
  #
  #         Whether configurations exist for instance.
  #
  def self.has_configurations?( instance )
    
    return ! configurations( instance ).empty?
    
  end

  #############################
  #  self.has_configuration?  #
  #############################

  ###
  # Query whether configuration has been registered for instance.
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
  #         Whether configuration has been registered for instance.
  #
  def self.has_configuration?( instance, configuration_name )

    return configurations( instance ).has_key?( configuration_name.to_sym )

  end

  ###############################
  #  self.remove_configuration  #
  ###############################
  
  ###
  # Unregister configuration for instance.
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
  def self.remove_configuration( instance, configuration_name )
    
    return configurations( instance ).delete( configuration_name )

  end
    
end
