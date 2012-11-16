
class ::CascadingConfiguration::Core::InstanceController < ::Module
  
  @instance_controllers = { }

  #####################################
  #  self.create_instance_controller  #
  #####################################
  
  def self.create_instance_controller( instance, extending = false )
    
    instance_controller = nil
    
    unless instance_controller = @instance_controllers[ instance ]
      instance_controller = new( instance, extending )
    end
    
    return instance_controller
    
  end
  
  ##############################
  #  self.instance_controller  #
  ##############################
  
  def self.instance_controller( instance, ensure_exists = false )
    
    instance_controller_instance = nil
    
    unless instance_controller_instance = @instance_controllers[ instance ]
      if ensure_exists
        exception_string = 'No module controller defined for :' << instance.to_s
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end

    return instance_controller_instance
    
  end

  ################
  #  initialize  #
  ################
  
  def initialize( instance, extending = false )

    @instance = instance.extend( ::Module::Cluster )
    
    if @instance.__is_a__?( ::Module )
      initialize_constant_in_instance
    else
      initialize_constant_in_self
    end

    # We manage reference to self in singleton from here to avoid duplicative efforts.
    reference_to_self = self
    self.class.class_eval do
      @instance_controllers[ instance ] = reference_to_self
    end

    @support_modules = { }
    
    # create a cascading block to register configurations for parent at include/extend
    initialize_inheritance_for_instance( @instance, extending )
        
  end
  
  #################################
  #  initialize_constant_in_self  #
  #################################
  
  def initialize_constant_in_instance

    @instance.const_set( :Controller, self )

  end
  
  #################################
  #  initialize_constant_in_self  #
  #################################
  
  def initialize_constant_in_self
    
    hex_id_string = '0x%x' % ( @instance.__id__ << 1 )
    constant = 'ID_' << hex_id_string
    self.class.const_set( :Controller, self )
    
    return self
    
  end

  #########################################
  #  initialize_inheritance_for_instance  #
  #########################################
  
  def initialize_inheritance_for_instance( instance, extending = false )

    unless instance.__is_a__?( ::Module::Cluster ) and 
           instance.has_cluster?( :cascading_configuration_inheritance )
      
      instance.extend( ::Module::Cluster )
      
      reference_to_self = self
      
      case instance
      
        when ::Class
        
          # Subclasses need to be told to cascade separately, as their cascade behavior is distinct
          instance.cluster( :cascading_configuration_inheritance ).subclass.cascade do |inheriting_instance|
            reference_to_self.initialize_inheriting_instance( self, inheriting_instance )
          end
      
        when ::Module
        
          # if we're extending then nothing cascades
          # we need this flag since the InstanceController could be created @ an initial extend.
          unless extending

            # Rather than creating cascade hooks we create single-action hooks.
            # This is so that the hook is created by the closest parent, as cascade hooks
            # would result in the parent being the original hook instance, not the most
            # recent hooked instance.
            
            instance.cluster( :cascading_configuration_inheritance ).before_include do |inheriting_instance|
              reference_to_self.initialize_inheriting_instance( self, inheriting_instance )
              reference_to_self.initialize_inheritance_for_instance( inheriting_instance )
            end

            instance.cluster( :cascading_configuration_inheritance ).before_extend do |inheriting_instance|
              reference_to_self.initialize_inheriting_instance( self, inheriting_instance )
            end

          end
          
      end

    end
    
  end
  
  ####################################
  #  initialize_inheriting_instance  #
  ####################################

  def initialize_inheriting_instance( parent_instance, instance )
    
    # Register newly inherited parent relation created by cascading hooks.
    ::CascadingConfiguration.register_parent( instance, parent_instance )
    
  end

  ##############
  #  instance  #
  ##############
  
  attr_reader :instance
  
  ####################
  #  create_support  #
  ####################
  
  def create_support( module_type_name,
                      support_module_class = ::CascadingConfiguration::Core::InstanceController::SupportModule,
                      should_include = false, 
                      should_extend = false, 
                      should_cascade_includes = false, 
                      should_cascade_extends = false,
                      module_constant_name = module_type_name.to_s.to_camel_case )

    # permit nil for support_module_class to default
    support_module_class ||= ::CascadingConfiguration::Core::InstanceController::SupportModule
    
    unless support_module_instance = @support_modules[ module_type_name = module_type_name.to_sym ]

      # New Instance
    
      support_module_instance = support_module_class.new( self, module_type_name )
      const_set( module_constant_name, support_module_instance )
      @support_modules[ module_type_name ] = support_module_instance
    
      # Cascades
    
      if should_cascade_includes
        @instance.cluster( :cascading_configuration ).after_include.cascade.include( support_module_instance )
      end
    
      if should_cascade_extends
        @instance.cluster( :cascading_configuration ).after_include.cascade.extend( support_module_instance )
      end
    
      # Includes/Extends
    
      if should_include
        case @instance
          # we can only include in modules
          when ::Module
            @instance.module_eval do
              include( support_module_instance )
            end
          # but we might be told to create instance support on instances, in which case we need to extend
          else
            @instance.extend( support_module_instance )
        end
      end
        
      if should_extend
        @instance.extend( support_module_instance )
      end

    end
    
    return support_module_instance
    
  end
 
  #############
  #  support  #
  #############
  
  def support( module_type_name )
    
    return @support_modules[ module_type_name.to_sym ]
    
  end
 
  ##############################
  #  create_singleton_support  #
  ##############################
  
  def create_singleton_support

    return create_support( :singleton, 
                           self.class::SupportModule::SingletonSupportModule, 
                           false, 
                           true, 
                           false, 
                           true )

  end

  #######################
  #  singleton_support  #
  #######################
  
  def singleton_support

    return support( :singleton )

  end

  #############################
  #  create_instance_support  #
  #############################

  def create_instance_support

    return create_support( :instance, 
                           self.class::SupportModule::InstanceSupportModule, 
                           true, 
                           false, 
                           true, 
                           false )

  end

  ######################
  #  instance_support  #
  ######################

  def instance_support

    return support( :instance )

  end

  ###################################
  #  create_local_instance_support  #
  ###################################

  def create_local_instance_support

    return create_support( :local_instance, nil, false, true, false, false )

  end

  ############################
  #  local_instance_support  #
  ############################

  def local_instance_support

    return support( :local_instance )

  end
  
  #############################
  #  define_singleton_method  #
  #############################

  def define_singleton_method( configuration_name, & method_proc )

    return create_singleton_support.define_method( configuration_name, & method_proc )

  end 

  #########################
  #  alias_module_method  #
  #########################
  
  def alias_module_method( alias_name, configuration_name )

    aliased_method = false
    
    if singleton_support_module = singleton_support
      aliased_method = singleton_support_module.alias_method( alias_name, configuration_name )
    end
    
    return aliased_method

  end

  ##########################
  #  remove_module_method  #
  ##########################

  def remove_module_method( configuration_name )

    removed_method = false

    if singleton_support_module = singleton_support
      removed_method = singleton_support_module.remove_method( configuration_name )
    end
    
    return removed_method
    
  end

  #########################
  #  undef_module_method  #
  #########################

  def undef_module_method( configuration_name )

    undefined_method = false

    if singleton_support_module = singleton_support
      undefined_method = singleton_support_module.undef_method( configuration_name )
    end
    
    return undefined_method
    
  end

  ############################
  #  define_instance_method  #
  ############################

  def define_instance_method( configuration_name, & method_proc )

    return create_instance_support.define_method( configuration_name, & method_proc )
    
  end

  ############################
  #  remove_instance_method  #
  ############################

  def remove_instance_method( configuration_name )

    removed_method = false

    if instance_support_module = instance_support
      removed_method = instance_support_module.remove_method( configuration_name )
    end
    
    return removed_method
    
  end

  ###########################
  #  undef_instance_method  #
  ###########################

  def undef_instance_method( configuration_name )

    undefined_method = false

    if instance_support_module = instance_support
      undefined_method = instance_support_module.undef_method( configuration_name )
    end
    
    return undefined_method
    
  end

  #######################################
  #  define_instance_method_if_support  #
  #######################################
  
  def define_instance_method_if_support( configuration_name, & method_proc )

    if instance_support_module = instance_support
      instance_support_module.define_method( configuration_name, & method_proc )
    end 
    
    return self
    
  end
  
  ###########################
  #  alias_instance_method  #
  ###########################
  
  def alias_instance_method( alias_name, configuration_name )

    aliased_method = false
    
    if instance_support_module = instance_support
      aliased_method = instance_support_module.alias_method( alias_name, configuration_name )
    end
    
    return aliased_method

  end

  ##################################
  #  define_local_instance_method  #
  ##################################

  def define_local_instance_method( configuration_name, & method_proc )

    return create_local_instance_support.define_method( configuration_name, & method_proc )

  end

  #################################
  #  alias_local_instance_method  #
  #################################
  
  def alias_local_instance_method( alias_name, configuration_name )

    aliased_method = false
    
    if local_instance_support_module = local_instance_support
      aliased_method = local_instance_support_module.alias_method( alias_name, configuration_name )
    end
    
    return aliased_method

  end
  
  ##################################
  #  remove_local_instance_method  #
  ##################################

  def remove_local_instance_method( configuration_name )

    removed_method = false

    if local_instance_support_module = local_instance_support
      removed_method = local_instance_support_module.remove_method( configuration_name )
    end
    
    return removed_method
    
  end
  
  #################################
  #  undef_local_instance_method  #
  #################################

  def undef_local_instance_method( configuration_name )

    undefined_method = false

    if local_instance_support_module = local_instance_support
      undefined_method = local_instance_support_module.undef_method( configuration_name )
    end
    
    return undefined_method
    
  end

  ###########################################
  #  define_singleton_and_instance_methods  #
  ###########################################

  def define_singleton_and_instance_methods( configuration_name, & method_proc )

    define_singleton_method( configuration_name, & method_proc )
    define_instance_method( configuration_name, & method_proc )

  end

  ############################################################
  #  define_singleton_method_and_instance_method_if_support  #
  ############################################################

  def define_singleton_method_and_instance_method_if_support( configuration_name, & method_proc )

    define_singleton_method( configuration_name, & method_proc )
    define_instance_method_if_support( configuration_name, & method_proc )

  end

  #######################################
  #  alias_module_and_instance_methods  #
  #######################################
  
  def alias_module_and_instance_methods( alias_name, configuration_name )
    
    alias_module_method( alias_name, configuration_name )
    alias_instance_method( alias_name, configuration_name )
    
  end
  
end
