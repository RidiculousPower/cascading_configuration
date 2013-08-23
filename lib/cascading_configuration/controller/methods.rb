# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Methods

  ########################
  #  read_method_module  #
  ########################

  ###
  # Value accessor and configuration read accessor
  #
  def read_method_module( configuration_name, read_accessor )
    
    configuration_name_sym   = configuration_name.to_sym
    read_accessor_sym        = read_accessor.to_sym
        
    unless read_method_modules = @read_method_modules[ configuration_name_sym ]
      @read_method_modules[ configuration_name_sym ] = read_method_modules = { }
    end
    
    unless read_method_module = read_method_modules[ read_accessor_sym ]
      read_method_module = self::ReadMethodModule.new( self, configuration_name, read_accessor_sym )
      read_method_modules[ read_accessor_sym ] = read_method_module
      storage_constant = method_module_storage_constant( configuration_name, read_accessor )
      self::ReadMethodModules.const_set( storage_constant, read_method_module )
    end
    
    return read_method_module
    
  end

  #########################
  #  write_method_module  #
  #########################

  def write_method_module( configuration_name, write_accessor )
    
    configuration_name_sym   = configuration_name.to_sym
    write_accessor_sym       = write_accessor.to_sym
        
    unless write_method_modules = @write_method_modules[ configuration_name_sym ]
      @write_method_modules[ configuration_name_sym ] = write_method_modules = { }
    end
    
    unless write_method_module = write_method_modules[ write_accessor_sym ]
      write_method_module = self::WriteMethodModule.new( self, configuration_name, write_accessor_sym )
      write_method_modules[ write_accessor_sym ] = write_method_module
      storage_constant = method_module_storage_constant( configuration_name, write_accessor )
      self::WriteMethodModules.const_set( storage_constant, write_method_module )
    end
    
    return write_method_module
    
  end
  
  ####################################
  #  method_module_storage_constant  #
  ####################################

  def method_module_storage_constant( configuration_name, accessor )
    
    accessor = accessor.accessor_name.to_s
    configuration_name = configuration_name.to_s
    
    # "?" and "!" are not valid in constant name, but unicode chars are
    # so we substitute "¿" and "¡"
    case configuration_name[ -1 ]
      when '?'
        configuration_name[ -1 ] = '¿'
      when '!'
        configuration_name[ -1 ] = '¡'
    end
    case accessor[ -1 ]
      when '?'
        accessor[ -1 ] = '¿'
      when '!'
        accessor[ -1 ] = '¡'
    end
    
    return 'Configuration«' << configuration_name.to_s << '•' << accessor << '»'
    
  end

end
