
module ::CascadingConfiguration::Core::IncludeCreatesInstanceSupport

  ##############
  #  included  #
  ##############
  
  ###
  # Include creates instance support for the instance in which include occurs.
  #
  def included( instance )

    super if defined?( super )
    
    # Ensure our instance has an instance controller
    unless instance_controller = ::CascadingConfiguration::Core::InstanceController.instance_controller( instance )
      instance_controller = ::CascadingConfiguration::Core::InstanceController.new( instance )
    end

    instance_controller.create_instance_support

  end
  
end