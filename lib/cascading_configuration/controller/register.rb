# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Register

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Runs #register_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be registered.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be registered for instance.
  #
  # @return 
  #
  def register_parent( instance, parent )
    
    case parent
      
      when ::Module

        if ::Module === instance
          register_include( instance, parent )
        else
          register_instance( instance, parent )
        end
        
      else

        # Inheriting from instance to module or class or other instance.
        # We have only instance configurations, so we have to decide what that means for module or class.
        # We make both singleton and instance configurations inherit from instance. 
        register_instance_to_instance( instance, parent )
        register_instance_to_singleton( instance, parent ) if ::Module === instance
        
    end
              
    return self
    
  end

  #####################################
  #  register_singleton_to_singleton  #
  #####################################
  
  def register_singleton_to_singleton( subclass, superclass )

    # singleton => singleton
    singleton_configurations( subclass ).register_parent( singleton_configurations( superclass ) )
    
  end

  ####################################
  #  register_singleton_to_instance  #
  ####################################
  
  def register_singleton_to_instance( subclass, superclass )

    # singleton => instance
    instance_configurations( subclass ).register_parent( singleton_configurations( superclass ) )
    
  end

  ####################################
  #  register_instance_to_singleton  #
  ####################################
  
  def register_instance_to_singleton( subclass, superclass )

    # instance => singleton
    singleton_configurations( subclass ).register_parent( instance_configurations( superclass ) )
    # object => singleton
    singleton_configurations( subclass ).register_parent( object_configurations( superclass ) )
    
  end

  ###################################
  #  register_instance_to_instance  #
  ###################################
  
  def register_instance_to_instance( subclass, superclass )

    # instance => instance
    instance_configurations( subclass ).register_parent( instance_configurations( superclass ) )
    # object => object
    object_configurations( subclass ).register_parent( object_configurations( superclass ) )
    
  end

end
