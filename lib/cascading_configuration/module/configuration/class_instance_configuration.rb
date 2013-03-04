# -*- encoding : utf-8 -*-

###
# Configurations created for Class will be extended with this module.
#
module ::CascadingConfiguration::Module::Configuration::ClassInstanceConfiguration
  
  ############
  #  parent  #
  ############
  
  ###
  # Get parent for configuration name on instance.
  #   Used in context where only one parent is permitted.
  #
  # @return [nil,::Object]
  #
  #         Parent instance registered for configuration.
  #
  def parent
    
    super if has_parents?
    
  end
  
end
