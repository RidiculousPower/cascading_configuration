# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Replace

  ####################
  #  replace_parent  #
  ####################
  
  ###
  # Runs #replace_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be replaceed.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be replaced for instance.
  #
  # @param [Object]
  #
  #        new_parent
  #
  #        Parent to replace old parent.
  #
  # @return Self.
  #
  def replace_parent( instance, parent, new_parent, event = nil )
    
    unregister_parent( instance, parent )
    register_parent( instance, new_parent, event )
    
    return self
    
  end

end
