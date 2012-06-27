
module ::CascadingConfiguration::Core::EnableInstanceSupport

  ##############
  #  included  #
  ##############
  
  def included( instance )
    
    super if defined?( super )
    
    # Ensure our instance has an instance controller
    unless instance_controller = ::CascadingConfiguration::Core::InstanceController.instance_controller( instance )
      default_encapsulation = self::ClassInstance.default_encapsulation
      instance_controller = ::CascadingConfiguration::Core::InstanceController.new( instance, default_encapsulation )
    end

    instance_controller.create_instance_support
    
  end
  
end
