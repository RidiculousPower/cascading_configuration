
RSpec::Matchers.define :have_created_support do |support_module,
                                                 module_type_name, 
                                                 module_inheritance_model, 
                                                 support_module_class, 
                                                 module_constant_name|

  fail_string = nil

  match do |instance_controller| 

    matched = true
    
    # module type
    unless matched = support_module.module_type_name == module_type_name
      fail_string = 'module type name (' << support_module.module_type_name.to_s << 
                    ') did not match expected (' << module_type_name.to_s << ').'
    end
    
    # class
    unless fail_string or matched = support_module.is_a?( support_module_class )
      fail_string = 'support module was not a ' << support_module_class.to_s
    end
    
    # constant
    unless fail_string or matched = instance_controller.const_get( module_constant_name ) == support_module
      fail_string = 'support module was not found at expected constant location ' << module_constant_name.to_s
    end
    
    # module inheritance model
    unless fail_string or matched = support_module.module_inheritance_model == module_inheritance_model
      fail_string = 'module inheritance model (' << support_module.module_inheritance_model.to_s << 
                    ') did not match expected (' << module_inheritance_model.to_s << ').'
    end

    matched

  end

  failure_message_for_should { fail_string }

end

RSpec::Matchers.define :have_been_extended_by do |support_module|

  fail_string = nil
  unexpected_success_string = nil

  match do |hooked_instance| 

    matched = nil
    
    unexpected_success_string = hooked_instance.to_s << ' was extended by ' << support_module.to_s << 
                                ' but not expected to be.'
    
    unless matched = hooked_instance.is_a?( support_module )
      fail_string = hooked_instance.to_s << ' was not extended by ' << support_module.to_s
    end
    
    matched

  end

  failure_message_for_should { fail_string }
  failure_message_for_should_not { unexpected_success_string }

end


RSpec::Matchers.define :have_included do |support_module|

  fail_string = nil
  unexpected_success_string = nil

  match do |hooked_instance| 

    matched = nil
    
    unexpected_success_string = hooked_instance.to_s << ' included ' << support_module.to_s << 
                                ' but not expected to have done so.'
    
    unless matched = hooked_instance.ancestors.include?( support_module )
      fail_string = hooked_instance.to_s << ' did not include ' << support_module.to_s
    end
    
    matched

  end

  failure_message_for_should { fail_string }

end
