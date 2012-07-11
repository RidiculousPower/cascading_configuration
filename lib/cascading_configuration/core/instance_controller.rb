
class ::CascadingConfiguration::Core::InstanceController < ::Module
  
  include ::ParallelAncestry::Inheritance
  
  @instance_controller = { }

  #####################################
  #  self.create_instance_controller  #
  #####################################
  
  def self.create_instance_controller( instance,
                                       default_encapsulation_or_name = ::CascadingConfiguration::Core::
                                                                         Module::DefaultEncapsulation, 
                                       constant = :Controller,
                                       extending = false )
    
    instance_controller = nil
    
    unless instance_controller = @instance_controller[ instance ]
      instance_controller = new( instance, default_encapsulation_or_name, constant, extending )
    end
    
    return instance_controller
    
  end
  
  ##############################
  #  self.instance_controller  #
  ##############################
  
  def self.instance_controller( instance, ensure_exists = false )
    
    instance_controller_instance = nil
    
    unless instance_controller_instance = @instance_controller[ instance ]
      if ensure_exists
        exception_string = 'No module controller defined for :' << instance.to_s
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end

    return instance_controller_instance
    
  end

  ######################################
  #  self.nearest_instance_controller  #
  ######################################
  
  def self.nearest_instance_controller( encapsulation, instance, name )
    
    instance_controller = nil
    
    this_parent = instance

    begin

      break if instance_controller = instance_controller( this_parent )

    end while this_parent = encapsulation.parent_for_configuration( this_parent, name )
    
    return instance_controller
    
  end
  
  ################
  #  initialize  #
  ################
  
  def initialize( instance, 
                  default_encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                  constant = :Controller,
                  extending = false )

    # Call to super is necessary for ParallelAncestry support.
    super()
    
    @instance = instance.extend( self )
    
    if @instance.is_a?( ::Module )
      @instance.const_set( constant, self )
      unless extending
        initialize_inheritance( @instance )
      end
    else
      hex_id_string = '0x%x' % ( @instance.__id__ << 1 )
      constant = 'ID_' << hex_id_string
      self.class.const_set( constant, self )
    end

    # We manage reference to self in singleton from here to avoid duplicative efforts.
    reference_to_self = self
    self.class.class_eval do
      @instance_controller[ instance ] = reference_to_self
    end
    
    # We need an encapsulation to manage automatic inheritance relations.
    @default_encapsulation = ::CascadingConfiguration::Core::
                               Encapsulation.encapsulation( default_encapsulation_or_name )
    
    # We also support arbitrary additional encapsulations.
    @encapsulations = { }
    
    @cascade_includes = ::Array::Unique.new( self )
    @cascade_extends = ::Array::Unique.new( self )
    
    @support_modules = { }
    
    @extension_modules = { }
        
  end
  
  ####################################
  #  initialize_inheriting_instance  #
  ####################################

  def initialize_inheriting_instance( parent_instance, instance, for_subclass = false, is_extending = false )

    super

    initialize_encapsulation_for_inheriting_instance( @default_encapsulation, parent_instance, instance )
    @encapsulations.each do |this_encapsulation_name, this_encapsulation|
      initialize_encapsulations_for_inheriting_instance( this_encapsulation, parent_instance, instance )
    end
    
    # subclass eigenclass inheritance is automatic; re-extending will only mess it up
    unless for_subclass
      unless is_extending or @cascade_extends.empty?
        # We collect cascade extends in accumulating order (oldest => youngest), which means we need to reverse
        # prior to including/extending (we need youngest => oldest).
        instance.extend( *@cascade_extends.reverse )
      end
      unless @cascade_includes.empty?
        if is_extending
          @cascade_includes.each do |this_include|
            case instance
              when ::Module
                unless instance.ancestors.include?( this_include )
                  instance.extend( this_include )
                end
              else
                instance.extend( this_include )
            end
          end
        elsif instance.is_a?( ::Module )
          cascade_includes = @cascade_includes
          instance.module_eval do
            # We collect cascade includes in accumulating order (oldest => youngest), which means we need to reverse
            # prior to including/extending (we need youngest => oldest).
            include( *cascade_includes.reverse )
          end
        end
      end
    end
    
  end
  
  ######################################################
  #  initialize_encapsulation_for_inheriting_instance  #
  ######################################################
  
  def initialize_encapsulation_for_inheriting_instance( encapsulation, parent_instance, instance )
    
    encapsulation.register_child_for_parent( instance, parent_instance )
    
  end

  ###########################
  #  default_encapsulation  #
  ###########################

  attr_reader :default_encapsulation

  ##############
  #  instance  #
  ##############
  
  attr_reader :instance
  
  ######################
  #  cascade_includes  #
  ######################

  attr_reader :cascade_includes

  #####################
  #  cascade_extends  #
  #####################

  attr_reader :cascade_extends

  ###########################
  #  add_extension_modules  #
  ###########################

  def add_extension_modules( name, 
                             encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                             *extension_modules, 
                             & definer_block )

    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    if block_given?
      
      new_module = self.class::ExtensionModule.new( self, encapsulation, name, & definer_block )

      constant_name = encapsulation.encapsulation_name.to_s.to_camel_case + '_' << name.to_s
      const_set( constant_name, new_module )

      extension_modules.push( new_module )

    end
    
    extension_modules.reverse!
    
    if extension_modules_array = @extension_modules[ name ]
      extension_modules_array.concat( extension_modules )
    else
      @extension_modules[ name ] = extension_modules_array = extension_modules
    end
    
    return extension_modules_array
    
  end
  
  #######################
  #  extension_modules  #
  #######################

  def extension_modules( name = nil, 
                         encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    extension_modules = nil
    
    if name
      extension_modules = @extension_modules[ name ]
    else
      extension_modules = @extension_modules
    end
    
    return extension_modules
    
  end

  ##############################
  #  extension_modules_upward  #
  ##############################
  
  def extension_modules_upward( name, 
                                encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )
    
    extension_modules = [ ]
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    this_ancestor = @instance
    
    begin
      
      if ancestor_controller = self.class.instance_controller( this_ancestor ) and
         these_modules = ancestor_controller.extension_modules( name, encapsulation )
        
        extension_modules.concat( these_modules )
      
      end
      
    end while this_ancestor = encapsulation.parent_for_configuration( this_ancestor, name )
    
    return extension_modules
    
  end

  ####################
  #  create_support  #
  ####################
  
  def create_support( module_type_name,
                      encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation,
                      support_module_class = ::CascadingConfiguration::Core::InstanceController::SupportModule,
                      should_include = false, 
                      should_extend = false, 
                      should_cascade_includes = false, 
                      should_cascade_extends = false,
                      module_constant_name = module_type_name.to_s.to_camel_case )

    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    # permit nil for support_module_class to default
    support_module_class ||= ::CascadingConfiguration::Core::InstanceController::SupportModule
    
    unless encapsulation_supports_hash = @support_modules[ encapsulation ]
      encapsulation_supports_hash = { }
      @support_modules[ encapsulation ] = encapsulation_supports_hash
    end
    
    unless support_module_instance = encapsulation_supports_hash[ module_type_name ]

      # New Instance
    
      support_module_instance = support_module_class.new( self, encapsulation, module_type_name )
    
      const_set( module_constant_name, support_module_instance )

      encapsulation_supports_hash[ module_type_name ] = support_module_instance
    
      # Cascades
    
      if should_cascade_includes
        @cascade_includes.push( support_module_instance ) 
      end
    
      if should_cascade_extends
        @cascade_extends.push( support_module_instance )      
      end
    
      # Includes/Extends
    
      if should_include
        case @instance
          # we can only include in modules
          when ::Module
            @instance.module_eval do
              include support_module_instance
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
  
  def support( module_type_name, encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )
    
    support_instance = nil
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    if encapsulation_supports_hash = @support_modules[ encapsulation ]
      support_instance = encapsulation_supports_hash[ module_type_name ]
    end
    
    return support_instance
    
  end
 
  ##############################
  #  create_singleton_support  #
  ##############################
  
  def create_singleton_support( encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    return create_support( :singleton, 
                           encapsulation_or_name, 
                           self.class::SupportModule::SingletonSupportModule, 
                           false, 
                           true, 
                           false, 
                           true )

  end

  #######################
  #  singleton_support  #
  #######################
  
  def singleton_support( encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    return support( :singleton, encapsulation_or_name )

  end

  #############################
  #  create_instance_support  #
  #############################

  def create_instance_support( encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    return create_support( :instance, 
                           encapsulation_or_name, 
                           self.class::SupportModule::InstanceSupportModule, 
                           true, 
                           false, 
                           true, 
                           false )

  end

  ######################
  #  instance_support  #
  ######################

  def instance_support( encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    return support( :instance, encapsulation_or_name )

  end

  ###################################
  #  create_local_instance_support  #
  ###################################

  def create_local_instance_support( encapsulation_or_name = ::CascadingConfiguration::Core::
                                                               Module::DefaultEncapsulation )

    return create_support( :local_instance, encapsulation_or_name, nil, false, true, false, false )

  end

  ############################
  #  local_instance_support  #
  ############################

  def local_instance_support( encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    return support( :local_instance, encapsulation_or_name )

  end
  
  ##################################
  #  define_configuration_methods  #
  ##################################

  def define_configuration_methods( ccm, encapsulation_or_name, method_types, names, & definer_block )

    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )

    accessors = parse_names_for_accessors( *names )
    
    accessors.each do |this_name, this_write_name|
      define_getter( ccm, this_name, this_name, method_types, encapsulation )
      define_setter( ccm, this_name, this_write_name, method_types, encapsulation )
    end
    
    return accessors
    
  end

  #############################
  #  define_singleton_method  #
  #############################

  def define_singleton_method( name, 
                               encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                               & method_proc )

    return create_singleton_support( encapsulation_or_name ).define_method( name, & method_proc )

  end 

  #########################
  #  alias_module_method  #
  #########################
  
  def alias_module_method( alias_name, 
                           name, 
                           encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    aliased_method = false
    
    if singleton_support = singleton_support( encapsulation_or_name )
      aliased_method = singleton_support.alias_method( alias_name, name )
    end
    
    return aliased_method

  end

  ##########################
  #  remove_module_method  #
  ##########################

  def remove_module_method( name, encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    removed_method = false

    if singleton_support = singleton_support( encapsulation_or_name )
      removed_method = singleton_support.remove_method( name )
    end
    
    return removed_method
    
  end

  #########################
  #  undef_module_method  #
  #########################

  def undef_module_method( name, encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    undefined_method = false

    if singleton_support = singleton_support( encapsulation_or_name )
      undefined_method = singleton_support.undef_method( name )
    end
    
    return undefined_method
    
  end

  ############################
  #  define_instance_method  #
  ############################

  def define_instance_method( name, 
                              encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                              & method_proc )

    return create_instance_support( encapsulation_or_name ).define_method( name, & method_proc )
    
  end

  ############################
  #  remove_instance_method  #
  ############################

  def remove_instance_method( name, 
                              encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    removed_method = false

    if instance_support = instance_support( encapsulation_or_name )
      removed_method = instance_support.remove_method( name )
    end
    
    return removed_method
    
  end

  ###########################
  #  undef_instance_method  #
  ###########################

  def undef_instance_method( name, 
                             encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    undefined_method = false

    if instance_support = instance_support( encapsulation_or_name )
      undefined_method = instance_support.undef_method( name )
    end
    
    return undefined_method
    
  end

  #######################################
  #  define_instance_method_if_support  #
  #######################################
  
  def define_instance_method_if_support( name, 
                                         encapsulation_or_name = ::CascadingConfiguration::Core::
                                                                   Module::DefaultEncapsulation, 
                                         & method_proc )

    if instance_support = instance_support( encapsulation_or_name )
      instance_support.define_method( name, & method_proc )
    end 
    
    return self
    
  end
  
  ###########################
  #  alias_instance_method  #
  ###########################
  
  def alias_instance_method( alias_name, 
                             name, 
                             encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    aliased_method = false
    
    if instance_support = instance_support( encapsulation_or_name )
      aliased_method = instance_support.alias_method( alias_name, name )
    end
    
    return aliased_method

  end

  ##################################
  #  define_local_instance_method  #
  ##################################

  def define_local_instance_method( name, 
                                    encapsulation_or_name = ::CascadingConfiguration::Core::
                                                              Module::DefaultEncapsulation, 
                                    & method_proc )

    return create_local_instance_support( encapsulation_or_name ).define_method( name, & method_proc )

  end

  #################################
  #  alias_local_instance_method  #
  #################################
  
  def alias_local_instance_method( alias_name, 
                                   name, 
                                   encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    aliased_method = false
    
    if local_instance_support = local_instance_support( encapsulation_or_name )
      aliased_method = local_instance_support.alias_method( alias_name, name, encapsulation_or_name )
    end
    
    return aliased_method

  end
  
  ##################################
  #  remove_local_instance_method  #
  ##################################

  def remove_local_instance_method( name, 
                                    encapsulation_or_name = ::CascadingConfiguration::Core::
                                                              Module::DefaultEncapsulation )

    removed_method = false

    if local_instance_support = local_instance_support( encapsulation_or_name )
      removed_method = local_instance_support.remove_method( name )
    end
    
    return removed_method
    
  end
  
  #################################
  #  undef_local_instance_method  #
  #################################

  def undef_local_instance_method( name, 
                                   encapsulation_or_name = ::CascadingConfiguration::Core::
                                                             Module::DefaultEncapsulation )

    undefined_method = false

    if local_instance_support = local_instance_support( encapsulation_or_name )
      undefined_method = local_instance_support.undef_method( name )
    end
    
    return undefined_method
    
  end

  ###########################################
  #  define_singleton_and_instance_methods  #
  ###########################################

  def define_singleton_and_instance_methods( name, encapsulation_or_name, & method_proc )

    define_singleton_method( name, encapsulation_or_name, & method_proc )
    define_instance_method( name, encapsulation_or_name, & method_proc )

  end

  ############################################################
  #  define_singleton_method_and_instance_method_if_support  #
  ############################################################

  def define_singleton_method_and_instance_method_if_support( name, encapsulation_or_name, & method_proc )

    define_singleton_method( name, encapsulation_or_name, & method_proc )
    define_instance_method_if_support( name, encapsulation_or_name, & method_proc )

  end

  #######################################
  #  alias_module_and_instance_methods  #
  #######################################
  
  def alias_module_and_instance_methods( alias_name, 
                                         name, 
                                         encapsulation_or_name = ::CascadingConfiguration::Core::
                                                                   Module::DefaultEncapsulation )
    
    alias_module_method( alias_name, name, encapsulation_or_name )
    alias_instance_method( alias_name, name, encapsulation_or_name )
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################
  
  ###################
  #  define_getter  #
  ###################

  def define_getter( ccm, 
                     name, 
                     accessor_name, 
                     method_types, 
                     encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    module_proc = ::Proc.new do
      return ccm.getter( encapsulation, self, name )
    end

    instance_proc = ::Proc.new do
      return ccm.instance_getter( encapsulation, self, name )
    end

    define_accessor( accessor_name, module_proc, instance_proc, method_types, encapsulation )

    return self

  end
  
  ###################
  #  define_setter  #
  ###################

  def define_setter( ccm, 
                     name, 
                     accessor_name, 
                     method_types, 
                     encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )

    module_proc = ::Proc.new do |value|
      return ccm.setter( encapsulation, self, name, value )
    end

    instance_proc = ::Proc.new do |value|
      return ccm.instance_setter( encapsulation, self, name, value )
    end
    
    define_accessor( accessor_name, module_proc, instance_proc, method_types, encapsulation )
    
    return self
    
  end

  ###############################
  #  parse_names_for_accessors  #
  ###############################
  
  def parse_names_for_accessors( *names )
    
    accessors = { }
    
    names.each do |this_name|

      case this_name

        when ::Hash
        
          this_name.each do |this_accessor_name, this_write_accessor_name|
            accessors[ this_accessor_name.accessor_name ] = this_write_accessor_name.write_accessor_name
          end
        
        else
        
          accessors[ this_name.accessor_name ] = this_name.write_accessor_name
        
      end

    end

    return accessors
    
  end

  #####################
  #  define_accessor  #
  #####################
  
  def define_accessor( accessor_name, module_proc, instance_proc, method_types, encapsulation )
    
    # Procs have already been defined by this point - they require the encapsulation,
    # so we require encapsulation here, expecting it already to have been looked up.
    
    method_types.each do |this_method_type|
      
      case this_method_type
        
        # Cascades through all includes, module and instance methods
        when :all

          define_singleton_method( accessor_name, encapsulation, & module_proc )
          define_instance_method_if_support( accessor_name, encapsulation, & instance_proc )
        
        # Module methods only
        when :module, :class
        
          define_singleton_method( accessor_name, encapsulation, & module_proc )
        
        # Instance methods only
        when :instance

          define_instance_method( accessor_name, encapsulation, & instance_proc )
        
        # Methods local to this instance and instances of it only
        when :local_instance
        
          case @instance
            when ::Module
              define_local_instance_method( accessor_name, encapsulation, & module_proc )
            else
              define_local_instance_method( accessor_name, encapsulation, & instance_proc )
          end
          define_instance_method_if_support( accessor_name, encapsulation, & instance_proc )

        # Methods local to this instance only
        when :object

          case @instance
            when ::Module
              define_local_instance_method( accessor_name, encapsulation, & module_proc )
            else
              define_local_instance_method( accessor_name, encapsulation, & instance_proc )
          end
        
      end
      
    end
    
    return self
    
  end
  
end
