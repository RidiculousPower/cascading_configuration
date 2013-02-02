
###
# Configurations that accept modules as arguments and a block to define a new module.
#   Modules are used to extend value held in configuration instance.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations < 
      ::CascadingConfiguration::Module::BlockConfigurations

  #############################
  #  parse_extension_modules  #
  #############################
  
  ###
  # Parse an array of configuration names and/or hash pairs for read/write names.
  #
  # @param [ Array< Symbol, String, Hash{ Symbol, String => Symbol, String } > ]
  #
  #        names_modules
  #
  #        Configuration name descriptors. 
  #        Symbols and Strings are read/write.
  #        Hash pairs are read => write.
  #
  # @return [ Hash{ Symbol => Symbol  } ]
  #
  def parse_extension_modules( names_modules )
    
    # We can have configuration names or modules - we need to separate them.
    names = [ ]
    modules = [ ]

    names_modules.each do |this_name_or_module|

      case this_name_or_module
        
        when ::Class

          raise ArgumentError, 'Module expected (received Class).'
        
        when ::Module

          modules.push( this_name_or_module )

        else
        
          names.push( this_name_or_module )
        
      end
      
    end
    
    names_modules_hash = { }
    
    # if we have a block to define extensions to the compositing object:
      
    names.each do |this_name|
      names_modules_hash[ this_name ] = modules
    end
    
    return names_modules_hash
    
  end
  
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
  def define_configurations( instance, method_types, *names_modules, & definer_block )
    
    module_defined_by_block = nil
        
    # Ask MethodModule to parse extension modules for these declarations on instance.
    names_modules_hash = parse_extension_modules( names_modules )

    names = names_modules_hash.keys

    super( instance, method_types, *names )

    instance_controller = ::CascadingConfiguration::InstanceController.instance_controller( instance )

    names_modules_hash.each do |this_configuration_name, these_modules|
      this_configuration = ::CascadingConfiguration.configuration( instance, this_configuration_name )
      if block_given?
        this_module_defined_by_block = instance_controller.class::ExtensionModule.new( self, 
                                                                                       this_configuration_name, 
                                                                                       & definer_block )
        constant_name = this_configuration_name.to_s.to_camel_case
        if instance.__is_a__?( ::Module )
          instance.const_set( constant_name, this_module_defined_by_block )
        end
        these_modules.push( this_module_defined_by_block )
      end
      unless these_modules.empty?
        this_configuration.extension_modules.unshift( *these_modules.reverse )
        this_configuration.value.extend( *this_configuration.extension_modules )
      end
    end
        
  end

end
