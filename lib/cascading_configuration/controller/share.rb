# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Share

  ##########################
  #  share_configurations  #
  ##########################
  
  def share_configurations( for_instance, with_instance )
    
    case for_instance
      when ::Module
        share_singleton_configurations( for_instance, with_instance )
        share_object_configurations( for_instance, with_instance )
    end
    
    share_instance_configurations( for_instance, with_instance )
    
    return self
    
  end

  ####################################
  #  share_singleton_configurations  #
  ####################################

  def share_singleton_configurations( with_instance, from_instance )

    objects_sharing_singleton_configurations( with_instance, true ).push( from_instance )
    singleton_configurations( with_instance ).share_configurations( singleton_configurations( from_instance ) )
    
    return self
    
  end

  ###################################
  #  share_instance_configurations  #
  ###################################

  def share_instance_configurations( with_instance, from_instance )

    objects_sharing_instance_configurations( with_instance, true ).push( from_instance )
    instance_configurations( with_instance ).share_configurations( instance_configurations( from_instance ) )

    return self
    
  end

  #################################
  #  share_object_configurations  #
  #################################

  def share_object_configurations( with_instance, from_instance )

    objects_sharing_object_configurations( with_instance, true ).push( from_instance )
    object_configurations( with_instance ).share_configurations( object_configurations( from_instance ) )

    return self
    
  end

  ##############################
  #  share_all_configurations  #
  ##############################
  
  def share_all_configurations( for_instance, with_instance )
    
    case for_instance
      when ::Module
        share_all_singleton_configurations( for_instance, with_instance )
        share_all_object_configurations( for_instance, with_instance )
    end
    
    share_all_instance_configurations( for_instance, with_instance )
    
    return self
    
  end
  
  ########################################
  #  share_all_singleton_configurations  #
  ########################################

  def share_all_singleton_configurations( for_instance, with_instance )
    
    shared_configurations = singleton_configurations( with_instance )

    case for_instance
      when ::Module
        @singleton_configurations[ for_instance.__id__ ] = shared_configurations
      else
        @instance_configurations[ for_instance.__id__ ] = shared_configurations
    end
    
    return shared_configurations
    
  end

  #######################################
  #  share_all_instance_configurations  #
  #######################################

  def share_all_instance_configurations( for_instance, with_instance )

    @instance_configurations[ for_instance.__id__ ] = shared_configurations = instance_configurations( with_instance )

    return shared_configurations
    
  end

  #####################################
  #  share_all_object_configurations  #
  #####################################

  def share_all_object_configurations( for_instance, with_instance )

    shared_configurations = object_configurations( with_instance )

    case for_instance
      when ::Module
        @object_configurations[ for_instance.__id__ ] = shared_configurations
      else
        @instance_configurations[ for_instance.__id__ ] = shared_configurations
    end
    
    return shared_configurations
    
  end
  
  ##############################################
  #  objects_sharing_singleton_configurations  #
  ##############################################
  
  def objects_sharing_singleton_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_singleton_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_singleton_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

  #############################################
  #  objects_sharing_instance_configurations  #
  #############################################
  
  def objects_sharing_instance_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_instance_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_instance_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

  ###########################################
  #  objects_sharing_object_configurations  #
  ###########################################

  def objects_sharing_object_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_object_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_object_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

end
