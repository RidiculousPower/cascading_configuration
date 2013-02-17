
class ::CascadingConfiguration::ConfigurationHash < ::Hash::Compositing

  ################
  #  initialize  #
  ################
  
  def initialize( parent_hash, configuration_instance, *args )
    
    super
    
    @include_extend_subclass_instance = { }
    
  end

  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_hash, parent_configuration_name, include_extend_subclass_instance = nil )
    
    parent_configuration = parent_hash[ parent_configuration_name ]

    if has_key?( parent_configuration_name )
      # if we already have a configuration then we want to register the parent as its parent
      # then we are done with lookup
      child_configuration = self[ parent_configuration_name ]
      child_configuration.register_parent( parent_configuration )
    else
      case parent_configuration.cascade_type
        when :local_instance, :object
          # if we have a configuration that is not intended to inherit, we want to skip it
          # nothing to do
        else
          # otherwise we have normal key handling
          super( parent_hash, parent_configuration_name )
          @include_extend_subclass_instance[ parent_configuration_name ] = include_extend_subclass_instance
      end
    end
        
    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################
  
  def unregister_parent( parent_hash )

    super
    
    parent_hash.each do |this_configuration_name, this_parent_configuration|
      if this_child_configuration = self[ this_configuration_name ] and
         this_child_configuration.is_parent?( this_parent_configuration )
        this_child_configuration.unregister_parent( this_parent_configuration )
      end
    end
    
    return self

  end

  ####################
  #  replace_parent  #
  ####################
  
  def replace_parent( parent_hash, new_parent_hash, include_extend_subclass_instance = nil )
    
    unregister_parent( parent_hash )
    register_parent( new_parent_hash, include_extend_subclass_instance )
    
    return self
    
  end
  
  ###################
  #  cascade_model  #
  ###################
  
  def cascade_model( parent_hash, configuration_name )
    
    # singleton => singleton
    # instance => instance
    # instance => singleton
    # singleton => instance
    
    # :singleton_to_singleton_and_instance_to_instance
    # singleton => singleton and instance => instance
    # :instance_to_instance
    # instance => instance
    # :singleton_to_instance
    # singleton => instance
    # :instance_to_singleton
    # instance => singleton
    
    instance = configuration_instance
    parent = parent_hash.configuration_instance

    case @include_extend_subclass_instance[ configuration_name ]

      when :include, :subclass
        
        # * module => class
        #   singleton => singleton
        #   instance => instance
        # * module => module
        #   singleton => singleton
        #   instance => instance
        # * class < module => class < module
        #   singleton => singleton
        #   instance => instance
        # * class => class
        #   singleton => singleton
        #   instance => instance
        cascade_model = :singleton_to_singleton_and_instance_to_instance
        
      when :extend
        
        # * module => class
        #   instance => singleton
        # * module => module
        #   instance => singleton
        # * module => instance (extend)
        #   instance => singleton
        cascade_model = :instance_to_singleton
    
      when :instance

        instance_class = instance.class
        if instance_class < ::Module and not instance_class < ::Class
          # * instance of class < module (a Module)
          #   instance => singleton
          cascade_model = :instance_to_singleton
        else
          # * instance of class (an Object)
          #   instance => instance
          cascade_model = :instance_to_instance
        end
      
      when nil
        
        case parent
          when ::Class
            case instance
              when ::Class, ::Module
                # * class => class
                #   singleton => singleton
                #   instance => instance
                # * class => module
                #   singleton => singleton
                #   instance => instance
                cascade_model = :singleton_to_singleton_and_instance_to_instance
              else
                # * class => instance
                #   instance => instance
                cascade_model = :instance_to_instance
            end
          when ::Module
            case instance
              when ::Class, ::Module
                # * module => module
                #   singleton => singleton
                #   instance => instance
                # * module => class
                #   singleton => singleton
                #   instance => instance
                cascade_model = :singleton_to_singleton_and_instance_to_instance
              else
                # * module => instance
                #   instance => instance
                cascade_model = :instance_to_instance
            end
          else
            # * instance => instance
            #   singleton => singleton
            #   instance => instance
            cascade_model = :singleton_to_singleton_and_instance_to_instance
        end
    
      when :singleton_to_singleton

        cascade_model = :singleton_to_singleton
      
    end
    
    return cascade_model
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################
  
  def child_pre_set_hook( configuration_name, parent_configuration, parent_hash )
    
    child_instance = nil
    
    instance = configuration_instance
    
    case cascade_model( parent_hash, configuration_name )
      when :singleton_to_singleton_and_instance_to_instance
        # we already handled :local_instance and :object in #register_parent_key
        child_instance = parent_configuration.class.new( instance, parent_configuration )
      when :instance_to_instance
        child_instance = parent_configuration.class.new( instance, parent_configuration, :instance )
      when :instance_to_singleton, :singleton_to_singleton
        child_instance = parent_configuration.class.new( instance, parent_configuration, :singleton )
    end
    
    return child_instance
    
  end

end

