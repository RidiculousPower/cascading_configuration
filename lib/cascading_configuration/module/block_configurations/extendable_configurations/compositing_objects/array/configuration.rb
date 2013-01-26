
###
# Configurations with Array::Compositing Objects.
#
class ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Array::Configuration < 
      ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration
  
  ###########################
  #  insert_new_parents_at  #
  ###########################
  
  ###
  # Location where new parents should be inserted.
  #
  # @!attribute [rw] insert_new_parents_at
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
  
  ###
  # Register a composite object instance as the parent of the instance associated with this configuration.
  #
  # @param parent_composite_object [Array::Compositing,Hash::Compositing]
  #
  #        Parent composite object instance.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def register_composite_object_parent( parent_composite_object )
  
    @value.register_parent( parent_composite_object, @insert_new_parents_at )
  
  end

end
