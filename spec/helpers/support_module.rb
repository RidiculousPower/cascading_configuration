# -*- encoding : utf-8 -*-

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
