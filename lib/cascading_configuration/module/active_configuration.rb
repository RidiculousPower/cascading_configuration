# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::Module::ActiveConfiguration < ::CascadingConfiguration::Module::Configuration

  #################################
  #  initialize«common_finalize»  #
  #################################
  
  def initialize«common_finalize»( for_instance, *parsed_args, & block )
    
    super
    
    @read_method_module  = @module.controller.read_method_module( @name, @name )
    @write_method_module = @module.controller.write_method_module( @name, @write_name )
    
    for_instance.extend( @read_method_module, @write_method_module )
    
  end

end
