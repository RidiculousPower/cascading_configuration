# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash < ::Hash::Compositing

  ################
  #  initialize  #
  ################
  
  def initialize( controller, instance )
    
    super( nil, instance )
    
    @controller = controller
    
  end

  #####################
  #  register_parent  #
  #####################
  
  def register_parent( parent_configurations, event = nil )
    
    super( parent_configurations )

    # we call load_parent_state in super, so we can use a simple flag
    # otherwise we have to store keyed data for lazy loading later
    @event = event
    load_parent_state
    @event = nil
    
    return self
    
  end
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )
    
    if existing_configuration = self[ configuration_name ]
      parent_configuration = parent_configurations[ configuration_name ]
      @event ? existing_configuration.register_parent_for_ruby_hierarchy( parent_configuration ) 
             : existing_configuration.register_parent( parent_configuration )
    else
      super
    end

    return configuration_name
    
  end

  #######################
  #  unregister_parent  #
  #######################
  
  def unregister_parent( parent_configurations )

    super
    
    parent_configurations.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ]
        this_child_configuration.unregister_parent( this_parent_configuration )
      end
    end
    
    return self

  end

  ####################
  #  replace_parent  #
  ####################
  
  def replace_parent( existing_parent, new_parent )

    super
    
    parent_configurations.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ] and
         this_new_parent = new_parent[ this_configuration_name ]
        this_child_configuration.replace_parent( this_parent_configuration, this_new_parent )
      end
    end
    
    return self

  end
    
end

