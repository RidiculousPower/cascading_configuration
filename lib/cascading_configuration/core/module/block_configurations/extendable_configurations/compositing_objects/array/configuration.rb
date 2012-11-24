
class ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::
        Array::Configuration < 
      ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::
        Configuration
  
  ###########################
  #  insert_new_parents_at  #
  ###########################
  
  ###
  # @!attribute [rw]
  #
  # @return [Integer,nil]
  #
  #         Integer is interpreted as an index.
  #         nil is interpreted as "after existing parents".
  #
  #         Default is nil.
  #
  attr_accessor :insert_new_parents_at
  
  ######################################
  #  register_composite_object_parent  #
  ######################################

  def register_composite_object_parent( parent_composite_object )
  
    @value.register_parent( parent_composite_object, @insert_new_parents_at )
  
  end

end
