# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash < ::Hash::Compositing

  ################
  #  initialize  #
  ################
  
  def initialize( configuration_instance, *args )
    
    super( nil, configuration_instance, *args )
    
    @include_extend_subclass_instance = { }
    
  end

  #####################
  #  register_parent  #
  #####################

  def register_parent( parent_hash, include_extend_subclass_instance = nil )

    @include_extend_subclass_instance[ parent_hash ] = include_extend_subclass_instance
    super( parent_hash )
    load_parent_state

    return self
    
  end

  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_hash, parent_configuration_name )
    
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
  
  def cascade_model( parent_hash )
    
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

    cascade_model =  case @include_extend_subclass_instance[ parent_hash ]

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
        :singleton_to_singleton_and_instance_to_instance
        
      when :extend
        
        # * module => class
        #   instance => singleton
        # * module => module
        #   instance => singleton
        # * module => instance (extend)
        #   instance => singleton
        :instance_to_singleton
    
      when :instance

        if ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
          # * instance of class < module (a Module)
          #   instance => singleton
          :instance_to_singleton
        else
          # * instance of class (an Object)
          #   instance => instance
          :instance_to_instance
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
                :singleton_to_singleton_and_instance_to_instance
              else
                # * class => instance
                #   instance => instance
                :instance_to_instance
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
                :singleton_to_singleton_and_instance_to_instance
              else
                # * module => instance
                #   instance => instance
                :instance_to_instance
            end
          else
            # * instance => instance
            #   singleton => singleton
            #   instance => instance
            :singleton_to_singleton_and_instance_to_instance
        end
    
      when :singleton_to_singleton

        :singleton_to_singleton
      
    end
    
    return cascade_model
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################
  
  def child_pre_set_hook( configuration_name, parent_configuration, parent_hash )
    
    child_instance = nil
    
    cascade_type = case cascade_model( parent_hash )
      when :singleton_to_singleton_and_instance_to_instance
        nil # inherit cascade type
      when :instance_to_instance
        :instance
      when :instance_to_singleton, :singleton_to_singleton
        :singleton
    end
    
    include_extend_subclass_instance = @include_extend_subclass_instance[ parent_hash ]

    return parent_configuration.class.new_inheriting_instance( configuration_instance, 
                                                               parent_configuration, 
                                                               cascade_type, 
                                                               include_extend_subclass_instance )
    
  end

end

