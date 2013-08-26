# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash < ::Hash::Compositing

  ################
  #  initialize  #
  ################
  
  def initialize( controller, instance )
    
    super( nil, instance )
    
    @controller = controller
    @event_for_parent = { }
    
  end

  #####################
  #  register_parent  #
  #####################
  
  def register_parent( parent_configurations, event = nil )
    
    @event_for_parent[ parent_configurations.__id__ ] = event
    super( parent_configurations )
    # we call load_parent_state so we can use a simple flag to track event
    # otherwise we have to store keyed data for lazy loading later
    load_parent_state
    
    return self
    
  end
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )

    if existing_configuration = self[ configuration_name ]
      parent_configuration = parent_configurations[ configuration_name ]
      event = @event_for_parent[ parent_configurations.__id__ ]
      event ? existing_configuration.register_parent_for_ruby_hierarchy( parent_configuration ) 
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

    parent_configurations.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ]
        this_child_configuration.unregister_parent( this_parent_configuration )
      end
    end
    
    super
    
    return self

  end

  ####################
  #  replace_parent  #
  ####################
  
  def replace_parent( existing_parent, new_parent )

    parent_configurations.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ] and
         this_new_parent = new_parent[ this_configuration_name ]
        this_child_configuration.replace_parent( this_parent_configuration, this_new_parent )
      end
    end
    
    super
    
    return self

  end
  
  ##########################
  #  share_configurations  #
  ##########################
  
  def share_configurations( configurations )

    if is_parent?( configurations )
      # replace each existing configuration with parent's configuration (achieved by marking as requiring lookup)
      configurations.each { |this_name, this_configuration| register_parent_key( configurations, this_name ) }
    else
      # register shared configurations as parent without declaring it as parent in controller
      register_parent( configurations )
    end
    
    return self
    
  end
   
end

