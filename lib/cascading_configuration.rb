
begin ; require 'development' ; rescue ::LoadError ; end

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

module ::CascadingConfiguration
  
  extend ::ParallelAncestry
  
  @configurations = ::CascadingConfiguration::AutoNestingIDHash.new
  @cascade_type_instances = { }
  
  define_cascade_type( :all ) { true }
  define_cascade_type( :singleton ) { |instance| ::Module === instance }
  define_cascade_type( :class ) { |instance| ::Class === instance }
  define_cascade_type( :module ) { |instance| ::Module === instance && ! ( ::Class === instance ) }
  define_cascade_type( :instance ) { |instance| true }
  define_cascade_type( :local_instance ) { true }
  define_cascade_type( :object ) { true }
  
  ###################
  #  self.included  #
  ###################
  
  ###
  # Include causes all defined cascading configuration modules to be included.
  #
  def self.included( instance )
    
    super if defined?( super )
    
    configuration_modules = ::CascadingConfiguration.configuration_modules
    
    instance.module_eval do
      configuration_modules.each do |this_member|
        include( this_member )
      end
    end
    
  end

  ###################
  #  self.extended  #
  ###################
  
  ###
  # Extend causes all defined cascading configuration modules to be extended.
  #
  def self.extended( instance )
    
    super if defined?( super )
    
    configuration_modules = ::CascadingConfiguration.configuration_modules
    
    configuration_modules.each do |this_member|
      instance.extend( this_member )
    end
    
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
  
  #############################
  #  self.define_method_type  #
  #############################
  
  ###
  # Define a method type to be added to all CascadingConfiguration modules or to specified modules.
  #
  # @overload self.define_method_type( cascade_type )
  #
  # @overload self.define_method_type( cascade_type, & block )
  #
  # @overload self.define_method_type( cascade_type, cascading_module, ... )
  #
  # @overload self.define_method_type( cascade_type, cascading_module, ..., & block )
  #
  # If cascade type does not already exist and a block is provided, it will be created.
  #
  def self.define_method_type( cascade_type, ccmodule_or_modules, & block )
    
    case cascade_type
      when ::Symbol, ::String
        cascade_type = ::CascadingConfiguration.cascade_type( cascade_type, false )
      when nil
        if block_given?
          cascade_type = ::CascadingConfiguration.define_cascade_type( cascade_type, & block )
        end
    end
    
    if ccmodules.empty?
      ccmodules = @configuration_modules
    end
    
    ccmodules.each do |this_ccm|
      this_ccm.define_configuration_method( cascade_type.name, cascade_type )
    end
    
  end

  ###################################
  #  self.define_local_method_type  #
  ###################################
  
  ###
  # Define a method type to be added to instance for all CascadingConfiguration modules or to specified modules.
  #
  # @overload self.define_local_method_type( instance, cascade_type )
  #
  # @overload self.define_local_method_type( instance, cascade_type, & block )
  #
  # @overload self.define_local_method_type( instance, cascade_type, cascading_module, ... )
  #
  # @overload self.define_local_method_type( instance, cascade_type, cascading_module, ..., & block )
  #
  def self.define_local_method_type( instance, cascade_type, *ccmodules, & block )
    
    case cascade_type
      when ::Symbol, ::String
        cascade_type = ::CascadingConfiguration.cascade_type( cascade_type, false )
      when nil
        if block_given?
          cascade_type = ::CascadingConfiguration.define_cascade_type( cascade_type, & block )
        end
    end
    
    if ccmodules.empty?
      ccmodules = @configuration_modules
    end
    
    ccmodules.each do |this_ccm|
      instance.define_singleton_method( )
    end
    
    
    
    instance.define_method( )
    
  end
  
  #########################
  #  self.configurations  #
  #########################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [ Object ] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ Hash{ Symbol, String => CascadingConfiguration::Module } ]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def self.configurations( instance )
    
    # the first time we get configurations for instance, register configurations defined in class
    unless @configurations.has_key?( instance ) or instance.equal?( ::Class )
      # create the instance_configurations hash so it won't loop
      @configurations[ instance ]
      register_parent( instance, instance.class )
    end
    
    return @configurations[ instance ]

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
  def self.define_configuration( instance, configuration_instance )
    
    configurations( instance )[ configuration_instance.name ] = configuration_instance
    
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
  def self.register_parent( instance, parent )
    
    super
    
    parent_configurations = configurations( parent )
    instance_configurations = configurations( instance )

    parent_configurations.each do |this_configuration_name, this_parent_configuration_instance|
      if this_parent_configuration_instance.should_cascade?( instance )
        if this_configuration_instance = instance_configurations[ this_configuration_name ]
          # if we already have this configuration
          this_configuration_instance.register_parent( this_parent_configuration_instance )
        else
          this_configuration_class = this_parent_configuration_instance.class
          this_configuration_instance = this_configuration_class.new( instance, this_parent_configuration_instance )
          instance_configurations[ this_configuration_name ] = this_configuration_instance
        end
      end
    end
        
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
    
    configurations( instance ).each do |this_configuration_name, this_configuration_instance|
      this_configuration_instance.unregister_parent( parent )
    end
        
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
    
    configurations( instance ).each do |this_configuration_name, this_configuration_instance|
      this_configuration_instance.replace_parent( parent, new_parent )
    end
        
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
