
class ::CascadingConfiguration::InstanceController::SupportModule < ::Module

  # Currently CascadingConfiguration uses three types:
  #
  # * Module Support - which cascade through includes and the first extend.
  # * Instance Support - which cascade through includes
  # * Local Instance Support - which do not cascade
  
  ################
  #  initialize  #
  ################
  
  def initialize( instance_controller, module_type_name, module_inheritance_model )
    
    @instance_controller = instance_controller
    @module_type_name = module_type_name
    @module_inheritance_model = module_inheritance_model

    @included = ::Array::Unique.new( self )
    @extended = ::Array::Unique.new( self )

    # include modules like ourselves above us
    existing_super_modules = super_modules
    unless existing_super_modules.empty?
      # Modules are gathered from lowest ancestor upward. This means that they are already 
      # in the proper order for include/extend (which usually we would have to reverse).
      include *existing_super_modules
    end

    cascade_new_support_for_child_modules
    
  end

  ######################
  #  module_type_name  #
  ######################
  
  attr_reader :module_type_name

  ##############################
  #  module_inheritance_model  #
  ##############################
  
  attr_reader :module_inheritance_model

  ##############
  #  included  #
  ##############

  def included( class_or_module )
    
    super
    
    @included.push( class_or_module )
    
  end
  
  ##############
  #  extended  #
  ##############
  
  def extended( class_or_module_or_instance )

    super
    
    @extended.push( class_or_module_or_instance )
    
  end

  ###############
  #  included?  #
  ###############

  def included?( class_or_module )

    return @included.include?( class_or_module )
    
  end
  
  ###############
  #  extended?  #
  ###############
  
  def extended?( class_or_module_or_instance )

    return @extended.include?( class_or_module_or_instance )
    
  end

  ###################
  #  super_modules  #
  ###################
  
  def super_modules
    
    return ::CascadingConfiguration.lowest_parents( @instance_controller.instance ) do |this_parent|
      ancestor_controller = ::CascadingConfiguration::InstanceController.instance_controller( this_parent )
      ancestor_controller and ancestor_support = ancestor_controller.support( @module_type_name )
    end.collect do |this_ancestor|
      ancestor_controller = ::CascadingConfiguration::InstanceController.instance_controller( this_ancestor )
      ancestor_controller.support( @module_type_name )
    end.uniq
    
  end

  ###################
  #  child_modules  #
  ###################
  
  def child_modules

    return ::CascadingConfiguration.highest_children( @instance_controller.instance ) do |this_child|
      ancestor_controller = ::CascadingConfiguration::InstanceController.instance_controller( this_child )
      ancestor_controller and ancestor_controller.support( @module_type_name )
    end.collect do |this_ancestor|
      ancestor_controller = ::CascadingConfiguration::InstanceController.instance_controller( this_ancestor )
      ancestor_controller.support( @module_type_name )
    end.uniq
    
  end

  ###########################################
  #  cascade_new_support_for_child_modules  #
  ###########################################
  
  def cascade_new_support_for_child_modules
    
    reference_to_self = self

    @included.each do |this_class_or_module|
      this_class_or_module.module_eval do
        include( reference_to_self )
      end
    end
    
    @extended.each do |this_class_or_module_or_instance|
      this_class_or_module_or_instance.extend( self )
    end

    child_modules.each do |this_child_module|

      this_child_module.module_eval do
        include( reference_to_self )
      end

      # and continue down this tree
      this_child_module.cascade_new_support_for_child_modules
      
    end
    
    return self
    
  end
  
  ###################
  #  define_method  #
  ###################
  
  # redefined to make public
  def define_method( method_name, *args, & block )
    
    return super
    
  end
  
  ##################
  #  alias_method  #
  ##################
  
  # redefined to make public
  def alias_method( alias_name, method_name )
    
    return super
    
  end
  
  ###################
  #  remove_method  #
  ###################
  
  # redefined to make public
  def remove_method( method_name )
    
    removed = false
    
    if method_defined?( method_name )
      super
      removed = true
    end
    
    return removed
    
  end
  
  ##################
  #  undef_method  #
  ##################
  
  # redefined to make public
  def undef_method( method_name )

    undefined = false
    
    if method_defined?( method_name )
      super
      undefined = true
    end
    
    return undefined
    
  end

end
