
module ::CascadingConfiguration::Core::EnableModuleSupport
  
  ##############
  #  extended  #
  ##############
  
  def extended( instance )
    
    super if defined?( super )
    
    # Ensure our instance has an instance controller
    unless instance_controller = ::CascadingConfiguration::Core::InstanceController.instance_controller( instance )
      instance_controller = ::CascadingConfiguration::Core::InstanceController.new( instance, 
                                                                                    @default_encapsulation,
                                                                                    :Controller,
                                                                                    true )
    end

    instance_controller.create_singleton_support
    
  end

end
