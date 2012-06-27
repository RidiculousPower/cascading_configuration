
class ::CascadingConfiguration::Core::InstanceController::ExtensionModule < ::Module

  ################
  #  initialize  #
  ################
  
  def initialize( instance_controller, encapsulation, configuration_name, & definer_block )
    
    @instance_controller = instance_controller
    @encapsulation = encapsulation
    @configuration_name = configuration_name
    
    if block_given?
      module_eval( & definer_block )
    end
    
  end

  #########################
  #  instance_controller  #
  #########################

  attr_reader :instance_controller

  ###################
  #  encapsulation  #
  ###################

  attr_reader :encapsulation
  
  ########################
  #  configuration_name  #
  ########################
  
  attr_reader :configuration_name
      
end
