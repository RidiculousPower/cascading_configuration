
class ::CascadingConfiguration::Core::Module::BlockConfigurations < ::CascadingConfiguration::Core::Module

  ###########################
  #  define_configurations  #
  ###########################
  
  ###
  # Define configurations for instance.
  #
  # @overload define_configurations( instance, method_types, configuration_name, ... )
  #
  #   @param [ Object ]
  #   
  #          instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  #   @param [ Array< Symbol, String > ]
  #   
  #          method_types
  #   
  #          Type of method being defined: 
  #   
  #            :all, :module, :class, :instance, :local_instance, :object.
  #
  #   @param [ Symbol, String, Hash{ Symbol, String => Symbol, String } ]
  #
  #          configuration_name
  #
  #          Name of configuration to be defined.
  #
  #   @yield [ ]
  #
  #          Block defining an additional module for extending configuration.
  #
  # @return Self.
  #
  def define_configurations( instance, method_types, *names_modules, & block )
    
    if block_given?
      @block = block
    end
    
    super( instance, method_types, *names_modules )
    
    return self
    
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################
  
  #################################
  #  define_configuration_method  #
  #################################

  ###
  # Define a configuration definition method with support for extendable configurations.
  #
  # @param [ Symbol, String ]
  # 
  #        ccm_method_name
  # 
  #        Name to use for configuration method.
  # 
  # @param [ Array< Symbol, String > ]
  # 
  #        method_types
  # 
  #        Type of method being defined: 
  #        
  #          :all, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_method( ccm_method_name, method_types )
    
    ccm = self

    #===================#
    #  ccm_method_name  #
    #===================#
    
    define_method( ccm_method_name ) do |*args, & block|

      ccm.define_configurations( self, method_types, *args, & block )                  
      
      return self
      
    end

    return self
    
  end

end
