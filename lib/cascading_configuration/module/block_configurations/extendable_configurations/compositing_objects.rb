
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects < 
      ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations
  
  ################
  #  initialize  #
  ################
  
  def initialize( module_type_name, compositing_object_class = nil, *module_type_name_aliases )
    
    super( module_type_name, *module_type_name_aliases )
    
    @compositing_object_class = compositing_object_class
    
  end

  ##############################
  #  compositing_object_class  #
  ##############################
  
  attr_reader :compositing_object_class

end
