
class ::CascadingConfiguration::Core::Encapsulation < ::Module

  include ::ParallelAncestry

  InstanceStruct = ::Struct.new( :configuration_variables_hash, 
                                 :configurations_hash, 
                                 :parent_for_configuration_hash )
  
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

  ###############################
  #  register_child_for_parent  #
  ###############################
  
  ###
  # Register all parent configurations for child instance with parent instance as parent.
  #
  # @param child
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
  def register_child_for_parent( child, parent )

    super

    # Modules already have configurations and if parent already has configurations 
    unless parent.is_a?( ::Module ) or has_parents?( parent )
      register_child_for_parent( parent, parent.class )
    end
    
    parent_configurations = configurations( parent )

    parent_configurations.each do |this_name, this_configuration_module|
      register_configuration( child, this_name, this_configuration_module )
      register_parent_for_configuration( child, parent, this_name )
    end
    
    return self

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
        
    parents_hash = parent_for_configuration_hash( child )
    
    # get module to determine whether we can have one ore multiple parents
    configuration_module = configurations( parent )[ configuration_name ]
    if configuration_module.permits_multiple_parents?
      
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
      
    else
      
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
      
    end
    
    return self
    
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
  
  ##############################
  #  parent_for_configuration  #
  ##############################
  
  ###
  # Get parent for configuration name on instance.
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
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  def parent_for_configuration( instance, configuration_name )
    
    parent = nil
    
    unless instance.equal?( ::Class )
      
      # get module to determine whether we can have one ore multiple parents
      # if we have no module that means configuration does not exist
      if configuration_module = configurations( instance )[ configuration_name ]

        if configuration_module.permits_multiple_parents?

          if parents = parent_for_configuration_hash( instance )[ configuration_name ]
            parent = parents[ 0 ]
          end
    
        else
      
          parent = parent_for_configuration_hash( instance )[ configuration_name ]

        end

      end

      unless parent
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

  ###
  # Get parents for configuration name on instance.
  #   Used in context where multiple parents are permitted.
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
      
      parents_hash = parent_for_configuration_hash( instance )
      
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
  # @return [true,false]
  #
  #         Whether parent exists for configuration.
  #
  def has_parent_for_configuration?( instance, configuration_name )
    
    has_parent_for_configuration = nil
    
    case parent_or_parents = parent_for_configuration_hash( instance )[ configuration_name ]
      
    when ::Array
      
      has_parent_for_configuration = ! parent_or_parents.empty?
      
    when nil
      
      has_parent_for_configuration = false
      
    else
       
       has_parent_for_configuration = true
       
    end
    
    return has_parent_for_configuration
    
  end
  
  #############################
  #  configuration_variables  #
  #############################
  
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
  def configuration_variables( instance )
    
    return configuration_struct( instance ).configuration_variables_hash ||= { }

  end

  #######################
  #  set_configuration  #
  #######################

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
  def set_configuration( instance, configuration_name, value )

    return configuration_variables( instance )[ configuration_name ] = value
    
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

    return configuration_variables( instance ).has_key?( configuration_name )

  end
  
  #######################
  #  get_configuration  #
  #######################
  
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
  def get_configuration( instance, configuration_name )
    
    return configuration_variables( instance )[ configuration_name ]

  end

  ###################################
  #  remove_configuration_variable  #
  ###################################
  
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
  def remove_configuration_variable( instance, configuration_name )
    
    return configuration_variables( instance ).delete( configuration_name )

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

  ############################################
  #  match_lowest_parents_for_configuration  #
  ############################################
  
  ###
  # Match lowest parents for configuration for which block returns true.
  #   Used in context where multiple parents are permitted.
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
  
  ###################################
  #  parent_for_configuration_hash  #
  ###################################
  
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
  def parent_for_configuration_hash( instance )
    
    return configuration_struct( instance ).parent_for_configuration_hash ||= { }

  end
  
end
