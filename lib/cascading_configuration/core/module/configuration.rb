
###
# @private
#
# Each declared configuration is backed by a Configuration object, 
#   which manages details specific to the configuration.
#
class ::CascadingConfiguration::Core::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  ###
  # 
  #
  def initialize( instance, configuration_module, configuration_name, write_accessor_name = configuration_name )

    @instance = instance

    @module = configuration_module
    @name = configuration_name.accessor_name
    @write_name = write_accessor_name.write_accessor_name

    @has_value = false
    
    initialize_for_instance
    
  end

  #############################
  #  initialize_for_instance  #
  #############################
  
  def initialize_for_instance

    # If we are defining configurations on ::Class we can only have explicit parents.
    case @instance
      
      when ::Class

        extend( self.class::ClassConfiguration )
        if @instance.equal?( ::Class )
          extend( self.class::ClassInstanceConfiguration )
        end

      when ::Module

        extend( self.class::ModuleConfiguration )

      else

        extend( self.class::InstanceConfiguration )
      
    end
    
  end

  ##############
  #  instance  #
  ##############
  
  attr_reader :instance
  
  ##########
  #  name  #
  ##########
  
  attr_reader :name

  ################
  #  write_name  #
  ################

  attr_reader :write_name

  ############
  #  module  #
  ############
  
  attr_reader :module

  ##############
  #  ancestor  #
  ##############
  
  attr_reader :ancestor
  
  #######################
  #  extension_modules  #
  #######################

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
  #        value
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
    
    @value = nil
    
    @has_value = false
    
    return self

  end

end