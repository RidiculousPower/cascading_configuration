# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Events

  #######################
  #  register_subclass  #
  #######################
  
  def register_subclass( subclass, superclass )

    register_singleton_to_singleton( subclass, superclass )
    register_instance_to_instance( subclass, superclass )
    
  end

  ######################
  #  register_include  #
  ######################

  def register_include( class_or_module, included_module )
    
    register_singleton_to_singleton( class_or_module, included_module )
    register_instance_to_instance( class_or_module, included_module )
    
  end

  #####################
  #  register_extend  #
  #####################

  def register_extend( instance, extending_module )

    register_instance_to_singleton( instance, extending_module )

  end
  
  #######################
  #  register_instance  #
  #######################

  def register_instance( instance, parent )

    register_instance_to_singleton( instance, parent )

  end

end
