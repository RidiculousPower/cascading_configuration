
class ::CascadingConfiguration::Core::Encapsulation < ::Module

  InstanceStruct = ::Struct.new( :configuration_values_hash, 
                                 :configurations_hash, 
                                 :parents_for_configuration_hash )
  
  @encapsulations = { }

  ########################
  #  self.encapsulation  #
  ########################
  
  ###
  # Retrieve encapsulation for name or instance.
  #
  # @param encapsulation_or_name
  #
  #        Encapsulation instance or name of encapsulation or nil.
  #        * If instance, instance is returned.
  #        * If name, instance corresponding to name is returned.
  #        * If nil, default encapsulation instance is returned.
  #
  # @param ensure_exists
  #
  #        Raise exception if encapsulation requested does not exist.
  #
  # @return [nil,::CascadingConfiguration::Core::Encapsulation]
  #
  #         Requested encapsulation instance.
  #
  def self.encapsulation( encapsulation_or_name, ensure_exists = false )
    
    encapsulation_instance = nil

    case encapsulation_or_name
      
      when nil
        
        encapsulation_instance = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
        
      when self
      
        encapsulation_instance = encapsulation_or_name
      
      when ::Symbol, ::String

        unless encapsulation_instance = @encapsulations[ encapsulation_or_name ]
          if ensure_exists
            exception_string = 'No encapsulation defined for :' << encapsulation_or_name.to_s
            exception_string << '.'
            raise ::ArgumentError, exception_string
          end
        end

    end
    
    return encapsulation_instance
    
  end

  ################
  #  initialize  #
  ################
  
  ###
  # Create encapsulation and store in encapsulation class instance.
  #
  # @param encapsulation_name
  #
  #        Name of encapsulation to create.
  #
  def initialize( encapsulation_name )

    super()
    
    @encapsulation_name = encapsulation_name
    
    encapsulation_instance = self
    
    # We manage reference to self in singleton from here to avoid duplicative efforts.
    self.class.class_eval do
      @encapsulations[ encapsulation_name ] = encapsulation_instance
      const_set( encapsulation_name.to_s.to_camel_case, encapsulation_instance )
    end
        
    @instances_hash = { }
    
  end

  ########################
  #  encapsulation_name  #
  ########################

  ###
  # Get name of encapsulation.
  #
  # @!attribute [r] encapsulation_name
  #
  # @return [::Symbol,::String] 
  #
  #         Encapsulation name.
  #
  attr_reader :encapsulation_name

  ############################
  #  register_configuration  #
  ############################

  ###
  # Record that a configuration is defined for this instance.
  #   This doesn't suggest that a configuration exists for this instance and name, 
  #   only that it has been registered to acknowledge it could exist.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @param configuration_module
  #
  #        Configuration module instance to be associated with configuration.
  #
  def register_configuration( instance, configuration_name, configuration_module )
    
    return configurations( instance )[ configuration_name ] = configuration_module

  end

  ####################
  #  configurations  #
  ####################
  
  ###
  # Get hash of configurations names and their corresponding 
  #   configuration modules that exist for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [::Hash{::Symbol,::String=>::CascadingConfiguration::Core::Module}]
  # 
  def configurations( instance )
    
    return configuration_struct( instance ).configurations_hash ||= { }

  end
  
  #########################
  #  configuration_names  #
  #########################
  
  ###
  # Get configuration names that exist for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [Array<::Symbol,::String>]
  #
  def configuration_names( instance )
    
    return configurations( instance ).keys

  end

  #########################
  #  has_configurations?  #
  #########################
  
  ###
  # Query whether any configurations exist for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [true,false] 
  #
  #         Whether configurations exist for instance.
  #
  def has_configurations?( instance )
    
    return ! configurations( instance ).empty?
    
  end

  ########################
  #  has_configuration?  #
  ########################

  ###
  # Query whether configuration has been registered for instance.
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
  #         Whether configuration has been registered for instance.
  #
  def has_configuration?( instance, configuration_name )

    has_configuration = nil
    
    unless has_configuration = configurations( instance ).has_key?( configuration_name ) or 
           instance == instance.class
      has_configuration = configurations( instance.class ).has_key?( configuration_name )
    end

    return has_configuration

  end

  ##########################
  #  remove_configuration  #
  ##########################
  
  ###
  # Unregister configuration for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  def remove_configuration( instance, configuration_name )
    
    return configurations( instance ).delete( configuration_name )

  end

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Creates in instance each configuration that exists for parent and registers parent
  #   as parent for each configuration.
  #
  # @param instance
  #
  #        Child instance for which configurations are being registered.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( instance, parent )
    
    parent_configurations = configurations( parent )

    parent_configurations.each do |this_name, this_configuration_module|
      register_configuration( child, this_name, this_configuration_module )
      register_parent_for_configuration( child, parent, this_name )
    end
    
    return self
    
  end
    
  #############################
  #  set_configuration_value  #
  #############################

  ###
  # Set configuration value.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @param value
  #
  #        Value of configuration.
  #
  def set_configuration_value( instance, configuration_name, value )

    return configuration_values( instance )[ configuration_name ] = value
    
  end

  #############################
  #  get_configuration_value  #
  #############################
  
  ###
  # Get configuration value for configuration name for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [::Object]
  #
  #         Configuration value.
  #
  def get_configuration_value( instance, configuration_name )
    
    return configuration_values( instance )[ configuration_name ]

  end

  ##############################
  #  has_configuration_value?  #
  ##############################

  ###
  # Query whether instance has a value set for configuration.
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
  #         Whether configuration name has value for instance.
  #
  def has_configuration_value?( instance, configuration_name )

    return configuration_values( instance ).has_key?( configuration_name )

  end
  
  ################################
  #  remove_configuration_value  #
  ################################
  
  ###
  # Unset value for configuration.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  def remove_configuration_value( instance, configuration_name )
    
    return configuration_values( instance ).delete( configuration_name )

  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##########################
  #  configuration_struct  #
  ##########################
  
  ###
  # Get configuration struct holding all instance information.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [::CascadingConfiguration::Core::Encapsulation::InstanceStruct]
  #
  #         Struct holding instance configurations and values.
  #
  def configuration_struct( instance )
    
    configuration_struct = nil
    
    instance_id = instance.__id__
    
    unless configuration_struct = @instances_hash[ instance_id ]
      # fill in slots lazily
      configuration_struct = self.class::InstanceStruct.new
      @instances_hash[ instance_id ] = configuration_struct
    end
    
    return configuration_struct
    
  end
  
  ####################################
  #  parents_for_configuration_hash  #
  ####################################
  
  ###
  # Get hash holding parents for each configuration for instance.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [::Hash{::Symbol,::String}=>::Object,::Array<::Object>]
  #
  #         Hash for instance with configuration names corresponding 
  #         to parent or array of parents.
  #
  def parents_for_configuration_hash( instance )
    
    return configuration_struct( instance ).parents_for_configuration_hash ||= { }

  end

  ##########################
  #  configuration_values  #
  ##########################
  
  ###
  # Get hash of configurations and their corresponding values.
  #
  # @param instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param configuration_name
  #
  #        Name of configuration.
  #
  # @return [::Hash{::Symbol,::String=>Object}]
  #
  #         Hash of configurations and their corresponding values.
  #
  def configuration_values( instance )
    
    return configuration_struct( instance ).configuration_values_hash ||= { }

  end
  
end
