
class ::CascadingConfiguration::Core::InstanceController::ExtensionModule < ::Module

  ################
  #  initialize  #
  ################
  
  def initialize( instance_controller, encapsulation, configuration_name, & definer_block )
    
    @instance_controller = instance_controller
    @encapsulation = encapsulation
    @configuration_name = configuration_name

    @pending_aliases = { }
            
    if block_given?
      module_eval( & definer_block )
    end
    
  end

  ##############
  #  extended  #
  ##############
  
  def extended( configuration_instance )
    
    create_pending_aliases( configuration_instance )
        
  end

  #########################
  #  instance_controller  #
  #########################

  attr_reader :instance_controller

  ###################
  #  encapsulation  #
  ###################

  attr_reader :encapsulation
  
  ########################
  #  configuration_name  #
  ########################
  
  attr_reader :configuration_name

  ############################
  #  create_pending_aliases  #
  ############################

  def create_pending_aliases( configuration_instance )
    
    created_aliases = false
    
    unless @pending_aliases.empty?
      pending_aliases = @pending_aliases
      eigenclass = class << configuration_instance ; self ; end
      eigenclass.instance_eval do
        pending_aliases.delete_if do |this_alias_name, this_method_name|
          should_delete = false
          if method_defined?( this_method_name )
            alias_method( this_alias_name, this_method_name )
            should_delete = true
          end
          should_delete
        end
      end
      created_aliases = true
    end
    
    return created_aliases
    
  end
  
  ##################
  #  alias_method  #
  ##################
  
  def alias_method( alias_name, method_name )
    
    aliased_method = false
    
    # if we don't respond to method, store it away so that we can alias it at extend time
    if method_defined?( method_name )
      super
      aliased_method = true
    else
      @pending_aliases[ alias_name ] = method_name
    end
    
    return aliased_method
    
  end
        
end
