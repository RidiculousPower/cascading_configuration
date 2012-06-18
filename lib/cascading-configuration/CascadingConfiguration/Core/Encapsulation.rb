
class ::CascadingConfiguration::Core::Encapsulation < ::Module

  include ::ParallelAncestry

  InstanceStruct = ::Struct.new( :configuration_variables_hash, 
                                 :configurations_hash, 
                                 :parent_for_configuration_hash )

  @encapsulations = { }

  ########################
  #  self.encapsulation  #
  ########################
  
  def self.encapsulation( encapsulation_or_name, ensure_exists = false )
    
    encapsulation_instance = nil

    case encapsulation_or_name
      
      when nil
        
        encapsulation_instance = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
        
      when self
      
        encapsulation_instance = encapsulation_or_name
      
      when ::Symbol, ::String

        unless encapsulation_instance = @encapsulations[ encapsulation_or_name ]
          if ensure_exists
            exception_string = 'No encapsulation defined for :' << encapsulation_or_name.to_s
            exception_string << '.'
            raise ::ArgumentError, exception_string
          end
        end

    end
    
    return encapsulation_instance
    
  end

  ################
  #  initialize  #
  ################
  
  def initialize( encapsulation_name )

    super()
    
    @encapsulation_name = encapsulation_name
    
    encapsulation_instance = self
    
    # We manage reference to self in singleton from here to avoid duplicative efforts.
    self.class.class_eval do
      @encapsulations[ encapsulation_name ] = encapsulation_instance
      const_set( encapsulation_name.to_s.to_camel_case, encapsulation_instance )
    end
        
    @instances_hash = { }
    
  end

  ########################
  #  encapsulation_name  #
  ########################

  attr_reader :encapsulation_name

  #########################
  #  has_configurations?  #
  #########################
  
  def has_configurations?( instance )
    
    return ! configurations( instance ).empty?
    
  end

  #########################
  #  configuration_names  #
  #########################
  
  def configuration_names( instance )
    
    return configurations( instance ).keys

  end
  
  ############################
  #  register_configuration  #
  ############################
  
  def register_configuration( instance, configuration_name, configuration_module )
    
    # Record that a configuration is defined for this instance.
    # 
    # This doesn't suggest that a configuration exists for this instance and name, only that it has 
    # been registered to acknowledge it could exist.
    return configurations( instance )[ configuration_name ] = configuration_module

  end

  ####################
  #  configurations  #
  ####################
  
  def configurations( instance )
    
    return configuration_struct( instance ).configurations_hash ||= { }

  end
  
  ########################
  #  has_configuration?  #
  ########################

  def has_configuration?( instance, configuration_name )

    has_configuration = nil

    unless has_configuration = configurations( instance ).has_key?( configuration_name )
      has_configuration = configurations( instance.class ).has_key?( configuration_name )
    end

    return has_configuration

  end

  ##########################
  #  remove_configuration  #
  ##########################
  
  def remove_configuration( instance, configuration_name )
    
    return configurations( instance ).delete( configuration_name )

  end

  ###############################
  #  register_child_for_parent  #
  ###############################
  
  def register_child_for_parent( child, parent )

    super
    
    # Modules already have configurations and if parent already has configurations 
    unless parent.is_a?( ::Module ) or parents( parent ).include?( parent.class )
      register_child_for_parent( parent, parent.class )
    end
  
    configurations( parent ).each do |this_name, this_configuration_module|
      register_parent_for_configuration( child, parent, this_name )
      register_configuration( child, this_name, this_configuration_module )
      this_configuration_module.create_configuration( self, child, this_name )
    end

  end

  #######################################
  #  register_parent_for_configuration  #
  #######################################
  
  def register_parent_for_configuration( child, parent, configuration_name )
    
    parent_for_configuration_hash( child )[ configuration_name ] = parent
    
    parents( child ).push( parent )
    
    return self
    
  end

  ##############################
  #  parent_for_configuration  #
  ##############################
  
  def parent_for_configuration( instance, configuration_name )

    unless parent = parent_for_configuration_hash( instance )[ configuration_name ]
      instance_class = instance.class
      if has_configuration?( instance_class, configuration_name )
        parent = instance_class
      end
    end

    return parent

  end

  #############################
  #  configuration_variables  #
  #############################
  
  def configuration_variables( instance )
    
    return configuration_struct( instance ).configuration_variables_hash ||= { }

  end

  #######################
  #  set_configuration  #
  #######################

  def set_configuration( instance, configuration_name, value )

    return configuration_variables( instance )[ configuration_name ] = value
    
  end

  ##############################
  #  has_configuration_value?  #
  ##############################

  def has_configuration_value?( instance, configuration_name )

    return configuration_variables( instance ).has_key?( configuration_name )

  end
  
  #######################
  #  get_configuration  #
  #######################
  
  def get_configuration( instance, configuration_name )
    
    return configuration_variables( instance )[ configuration_name ]

  end

  ###################################
  #  remove_configuration_variable  #
  ###################################
  
  def remove_configuration_variable( instance, configuration_name )
    
    return configuration_variables( instance ).delete( configuration_name )

  end
  
  ##################
  #  match_parent  #
  ##################
  
  def match_parent( instance, configuration_name, & match_block )
    
    matched_parent = nil
    
    this_parent = instance
    
    begin
      
      if match_block.call( this_parent )
        matched_parent = this_parent
        break
      end
      
    end while this_parent = parent_for_configuration( this_parent, configuration_name )
    
    return matched_parent
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##########################
  #  configuration_struct  #
  ##########################
  
  def configuration_struct( instance )
    
    configuration_struct = nil
    
    instance_id = instance.__id__
    
    unless configuration_struct = @instances_hash[ instance_id ]
      # fill in slots lazily
      configuration_struct = self.class::InstanceStruct.new
      @instances_hash[ instance_id ] = configuration_struct
    end
    
    return configuration_struct
    
  end
  
  ###################################
  #  parent_for_configuration_hash  #
  ###################################
  
  def parent_for_configuration_hash( instance )
    
    return configuration_struct( instance ).parent_for_configuration_hash ||= { }

  end
  
end
