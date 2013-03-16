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
  
  def register_parent( parent_hash, event = nil )
    
    # we call load_parent_state in super, so we can use a simple flag
    # instead of storing data for lazy loading later
    @event = event

    super( parent_hash )
    load_parent_state

    @event = nil
    
  end
  
  #######################
  #  unregister_parent  #
  #######################
  
  def unregister_parent( parent_hash )

    super
    
    parent_hash.each do |this_configuration_name, this_parent_configuration|
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
    
    parent_hash.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ] and
         this_new_parent = new_parent[ this_configuration_name ]
        this_child_configuration.replace_parent( this_parent_configuration, this_new_parent )
      end
    end
    
    return self

  end
  
end

