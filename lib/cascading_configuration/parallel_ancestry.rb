# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::ParallelAncestry
  
  #######################
  #  register_subclass  #
  #######################
  
  def register_subclass( subclass, superclass )

    super
    ::CascadingConfiguration.register_subclass( subclass, superclass ) unless @suspended
    
  end

  ######################
  #  register_include  #
  ######################

  def register_include( class_or_module, including_module )
    
    super
    ::CascadingConfiguration.register_include( class_or_module, including_module ) unless @suspended

  end

  #####################
  #  register_extend  #
  #####################

  def register_extend( instance, extending_module )

    super
    ::CascadingConfiguration.register_extend( instance, extending_module ) unless @suspended

  end

  #######################
  #  register_instance  #
  #######################

  def register_instance( instance, parent_instance )

    super
    ::CascadingConfiguration.register_instance( instance, parent_instance ) unless @suspended

  end

  
end
