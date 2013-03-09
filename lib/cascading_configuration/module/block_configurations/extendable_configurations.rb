# -*- encoding : utf-8 -*-

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
  #   @param [ Object ]
  #   
  #          instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  # @param [Array<Symbol,String,Hash{Symbol,String=>Symbol,String}>]
  #
  #        names_modules
  #
  #        Configuration name descriptors. 
  #        Symbols and Strings are read/write.
  #        Hash pairs are read => write.
  #
  # @return [ Hash{ Symbol => Symbol  } ]
  #
  def parse_extension_modules( instance, names_modules, & definer_block )
    
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

    # if we have a block to define extensions to the compositing object:
    if block_given?
      extension_module_name = names.join( '•' )
      instance_controller = ::CascadingConfiguration::InstanceController.instance_controller( instance )
      new_block_module = ::CascadingConfiguration::InstanceController::ExtensionModule.new( instance_controller, 
                                                                                            extension_module_name, 
                                                                                            & definer_block )
      constant_name = 'ExtensionModule«' << extension_module_name << '»'
      instance_controller.const_set( constant_name, new_block_module )
      modules.unshift( new_block_module )
    end
    
    names_modules_hash = { }
          
    names.each { |this_name| names_modules_hash[ this_name ] = modules }
    
    return names_modules_hash
    
  end
  
  ###########################
  #  define_configurations  #
  ###########################
  
  ###
  # Define configurations for instance.
  #
  # @overload define_configurations( instance, method_type, configuration_name, ... )
  #
  #   @param [ Object ]
  #   
  #          instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  #   @param [Symbol,String]
  #   
  #          method_type
  #   
  #          Type of method being defined: 
  #   
  #            :singleton_and_instance, :module, :class, :instance, :local_instance, :object.
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
  def define_configurations( instance, method_type, *names_modules, & definer_block )
    
    module_defined_by_block = nil
        
    # Ask MethodModule to parse extension modules for these declarations on instance.
    names_modules_hash = parse_extension_modules( instance, names_modules, & definer_block )
    names = super( instance, method_type, *names_modules_hash.keys )

    names_modules_hash.each do |this_configuration_name, these_modules|
      this_configuration_name = this_configuration_name.first[ 0 ] if ::Hash === this_configuration_name
      this_configuration = ::CascadingConfiguration.configuration( instance, this_configuration_name )
      this_configuration.declare_extension_modules( *these_modules )
    end
        
  end

end
