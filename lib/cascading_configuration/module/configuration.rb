
###
# @private
#
# Each declared configuration is backed by a Configuration object, 
#   which manages details specific to the configuration.
#
class ::CascadingConfiguration::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  ###
  # @overload new( instance, cascade_type, configuration_module, configuration_name, write_accessor_name = configuration_name )
  #
  # @overload new( instance, parent_configuration, cascade_type = nil )
  #
  def initialize( instance, *args )

    @instance = instance

    case arg_zero = args[ 0 ]
      when self.class
        # we assume all parent instances provided have matching module/name
        @parent = arg_zero
        @module = @parent.module
        @name = @parent.name
        @write_name = @parent.write_name
        @cascade_type = args[ 1 ] || @parent.cascade_type
      else
        @cascade_type = arg_zero
        @module = args[ 1 ]
        @name = args[ 2 ].accessor_name
        @write_name = ( args[ 3 ] || @name ).write_accessor_name
    end

    @has_value = false
    
    initialize_for_instance
    
  end

  #############################
  #  initialize_for_instance  #
  #############################
  
  ###
  # @private
  #
  # Extends self with appropriate module(s) given instance for which initilization is occuring.
  #
  def initialize_for_instance

    # If we are defining configurations on ::Class we can only have explicit parents.
    case @instance
      
      when ::Class

        extend( self.class::ClassConfiguration )

        if @instance.equal?( ::Class )
          extend( self.class::ClassInstanceConfiguration )
        elsif instance_class = @instance.class and
              instance_class < ::Module and not instance_class < ::Class
          extend( self.class::ClassInheritingFromModuleConfiguration )
        end

      when ::Module

        extend( self.class::ModuleConfiguration )

      else

        extend( self.class::InstanceConfiguration )
      
    end
    
  end
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  ###
  # Query whether configuration permits multiple parents.
  #
  # @return [false]
  #
  #         Whether multiple parents are permitted.
  #
  def permits_multiple_parents?
    
    return false
    
  end

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( parent )
        
    @parent = parent
    
    return self
    
  end

  ############
  #  parent  #
  ############
  
  ###
  # Get parent for configuration name on instance.
  #   Used in context where only one parent is permitted.
  #
  # @!attribute [r] parent
  #
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  attr_reader :parent

  ####################
  #  replace_parent  #
  ####################

  ###
  # Replace parent for configuration instance with a different parent.
  #
  # @overload replace_parent( new_parent )
  #
  #   @param new_parent
  #   
  #          New parent instance.
  #
  # @overload replace_parent( existing_parent, new_parent )
  #
  #   @param existing_parent
  #   
  #          Existing parent instance (ignored).
  #
  #   @param new_parent
  #   
  #          New parent instance.
  #
  # @return [self]
  #
  #         Self.
  #
  def replace_parent( *args )
    
    new_parent = nil
    existing_parent = nil
    
    case args.size
      when 1
        new_parent = args[ 0 ]
      when 2
        # existing_parent = args[ 0 ]
        new_parent = args[ 1 ]
    end
  
    unregister_parent
    register_parent( new_parent )

    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################

  ###
  # Remove parent for configuration instance .
  #
  # @return [self]
  #
  #         Self.
  #
  def unregister_parent( *args )
    
    @parent = nil

    return self
  
  end

  ##################
  #  has_parents?  #
  ##################

  ###
  # Query whether one or more parents exist.
  #   Used in context where only one parent is permitted.
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
  #         Whether parent exists for configuration.
  #
  def has_parents?
    
    return @parent ? true : false
    
  end

  ################
  #  is_parent?  #
  ################
  
  ###
  # Query whether potential parent instance is a parent for configuration in instance.
  #
  # @param potential_parent
  #
  #        Potential parent instance being queried.
  #
  # @return [ true, false ]
  #
  #         Whether potential parent instance is parent for configuration name.
  #
  def is_parent?( potential_parent )
    
    return potential_parent.equal?( @parent )
    
  end
    
  ##################
  #  cascade_type  #
  ##################
  
  ###
  # Cascade type for which configuration was created.
  #
  # @!attribute [rw] instance
  #
  # @return [:singleton_and_instance,:singleton,:instance,:local_instance,:object] instance.
  #
  attr_accessor :cascade_type

  ##############
  #  instance  #
  ##############
  
  ###
  # Instance for which configuration exists.
  #
  # @!attribute [r] instance
  #
  # @return [Object] instance.
  #
  attr_reader :instance
  
  ##########
  #  name  #
  ##########
  
  ###
  # Configuration name and read accessor.
  #
  # @!attribute [r] name
  #
  # @return [Symbol,String] configuration name.
  #
  attr_reader :name

  ################
  #  write_name  #
  ################

  ###
  # Configuration write accessor.
  #
  # @!attribute [r] write_name
  #
  # @return [Symbol,String] configuration write name.
  #
  attr_reader :write_name

  ############
  #  module  #
  ############
  
  ###
  # Configuration module for which configuration exists.
  #
  # @!attribute [r] module
  #
  # @return [CascadingConfiguration::Module] Configuration module.
  #
  attr_reader :module

  #######################
  #  extension_modules  #
  #######################

  ###
  # Extension modules associated with configuration.
  #
  # @!attribute [r] extension_modules
  #
  # @return [Array::Unique] Extension modules.
  #
  attr_reader :extension_modules

  ################
  #  has_value?  #
  ################

  ###
  # Query whether instance has a value set for configuration.
  #
  # @return [ true, false ]
  #
  #         Whether configuration name has value for instance.
  #
  def has_value?

    return @has_value

  end
  
  ############
  #  value   #
  ############
  
  ###
  # Get configuration value for configuration name for instance.
  #
  # @return [::Object]
  #
  #         Configuration value.
  #
  def value
    
    return @value

  end

  ############
  #  value=  #
  ############

  ###
  # Set configuration value.
  #
  # @param [ Object ]
  #
  #        object
  #
  #        Value of configuration.
  #
  def value=( object )
    
    @has_value = true
    @value = object
    
  end

  ##################
  #  remove_value  #
  ##################
  
  ###
  # Unset value for configuration.
  #
  # @return Self.
  #
  def remove_value
    
    @has_value = false
    @value = nil
        
    return self

  end

end
