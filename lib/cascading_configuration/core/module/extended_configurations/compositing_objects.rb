
class ::CascadingConfiguration::Core::Module::ExtendableConfigurations::CompositingObjects < 
      ::CascadingConfiguration::Core::Module::ExtendableConfigurations
  
  ################
  #  initialize  #
  ################
  
  def initialize( module_type_name, compositing_object_class = nil, *module_type_name_aliases )
    
    super( module_type_name, *module_type_name_aliases )
    
    @compositing_object_class = compositing_object_class
    
  end

  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  def permits_multiple_parents?
    
    return true
    
  end

  ##############################
  #  compositing_object_class  #
  ##############################
  
  attr_reader :compositing_object_class

  ############
  #  value=  #
  ############
  
  def value=( value )

    return @value.replace( value )
    
  end

end
