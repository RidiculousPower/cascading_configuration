# -*- encoding : utf-8 -*-

###
# Support for enabling Configuration Modules. 
#   Defined separately so that it can load before modules that depend upon it.
#
module ::CascadingConfiguration::Modules

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( controller_instance )
    
    controller_instance.instance_eval do
      @configuration_modules = ::Array::Unique.new
    end
    
  end

  ###########################
  #  configuration_modules  #
  ###########################
  
  def configuration_modules
    
    return @configuration_modules
    
  end
  
  ###################################
  #  register_configuration_module  #
  ###################################
  
  def register_configuration_module( configuration_module )
    
    @configuration_modules.push( configuration_module )
    configuration_module.controller = self
    
    return self
    
  end
  
end
