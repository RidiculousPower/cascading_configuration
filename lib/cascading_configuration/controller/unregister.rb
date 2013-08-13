# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Unregister

  #######################
  #  unregister_parent  #
  #######################
  
  ###
  # Runs #unregister_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be unregistered.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be unregistered for instance.
  #
  # @return 
  #
  def unregister_parent( instance, parent )
    
    super
    
    case instance
      when ::Module
        if ! ( ::Class === instance ) and 
           ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
          if parent_instance_configurations = instance_configurations( parent, false )
            if singleton_configurations = singleton_configurations( instance, false )
              singleton_configurations.unregister_parent( parent_instance_configurations )
            end
          end
        else
          if parent_singleton_configurations = singleton_configurations( parent, false )
            if singleton_configurations = singleton_configurations( instance, false )
              singleton_configurations.unregister_parent( parent_singleton_configurations )
            end
          end
          if parent_instance_configurations = instance_configurations( parent, false )
            if instance_configurations = instance_configurations( instance, false )
              instance_configurations.unregister_parent( parent_instance_configurations )
            end
          end
        end
      else
        parent_configurations = case parent
          when ::Module
            singleton_configurations( parent, false )
          else
            instance_configurations( parent, false )
        end
        instance_configurations( instance ).unregister_parent( parent_configurations ) if parent_configurations
    end

    return self
    
  end

end
