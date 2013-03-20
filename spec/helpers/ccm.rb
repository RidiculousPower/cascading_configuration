# -*- encoding : utf-8 -*-

RSpec::Matchers.define :have_cascaded do |event, parent_instance, name, write_name, active_parent_configuration, has_methods, has_instance_methods, should_cascade_hook, inheritance_parent_is_class|

  fail_string = nil
  unexpected_success_string = nil

  match do |hooked_instance| 

    unexpected_success_string = 'configuration cascaded to ' << hooked_instance.to_s << 
                                ' but was not expected to do so.'
    
    # * should have cascaded hook
    if should_cascade_hook
      unless ::Module::Cluster === hooked_instance and
             hooked_instance.has_cluster?( :cascading_configuration_inheritance ) ||
             ::Class === parent_instance ||
             inheritance_parent_is_class # class methods are inherited, so class B has the hook even though it
                                         # was not specifically enabled
        fail_string = 'inheritance hook did not cascade to ' << hooked_instance.name.to_s
      end
    end

    singleton_configuration = nil
    instance_configuration = nil
    singleton_parent = nil
    instance_parent = nil
    if has_methods
      unless fail_string or
             singleton_configuration = ::CascadingConfiguration.configuration( hooked_instance, name, false )
        fail_string = 'configuration was not created for ' << hooked_instance.name.to_s
      end
      unless fail_string or ! parent_instance
        if singleton_configuration.parent.nil?
          fail_string = 'active configuration :' << singleton_configuration.name.to_s << ' for ' << 
                        hooked_instance.name.to_s << ' did not have expected parent ' << parent_instance.name.to_s << 
                        ' (had nil)'
        end
        unless fail_string
          if active_parent_configuration
            unless singleton_parent = ::CascadingConfiguration.configuration( parent_instance, name, false )
              fail_string = 'active configuration did not exist for ' << parent_instance.name.to_s << 
                            ' (parent of active configuration for ' << hooked_instance.name.to_s << ')'
            end
          else
            unless singleton_parent = ::CascadingConfiguration.instance_configuration( parent_instance, name, false )
              fail_string = 'inactive configuration did not exist for ' << parent_instance.name.to_s << 
                            ' (parent of active configuration for ' << hooked_instance.name.to_s << ')'
            end
          end
          unless fail_string or
                 singleton_configuration.parent.equal?( singleton_parent )
            fail_string = ( active_parent_configuration ? 'active' : 'inactive' ) << ' parent configuration for ' << 
                          hooked_instance.name.to_s << ' did not belong to ' << parent_instance.name.to_s << 
                          ' (belongs to ' << singleton_configuration.parent.instance.name.to_s << ')'
          end
        end
      end
    end
    if has_instance_methods
      unless fail_string or
             instance_configuration = ::CascadingConfiguration.instance_configuration( hooked_instance, name, false ) ||
                                      ::CascadingConfiguration.object_configuration( hooked_instance, name, false )
        fail_string = 'instance configuration was not created for ' << hooked_instance.name.to_s
      end
      unless fail_string or ! parent_instance
        if has_methods
          unless instance_parent = ::CascadingConfiguration.configuration( hooked_instance, name, false )
            fail_string = 'active configuration did not exist for ' << hooked_instance.name.to_s << 
                          ' (parent of inactive configuration for ' << hooked_instance.name.to_s << ')'
          end
          unless fail_string
            if instance_configuration.parent.nil?
              fail_string = 'inactive configuration :' << instance_configuration.name.to_s << ' for ' << 
                            hooked_instance.name.to_s << ' did not have expected parent active configuration in ' << 
                            'self (had nil)'
            end
          end
        else
          unless instance_parent = ::CascadingConfiguration.instance_configuration( parent_instance, name, false ) ||
                                   ::CascadingConfiguration.object_configuration( parent_instance, name, false )
            fail_string = 'inactive configuration did not exist for ' << parent_instance.name.to_s << 
                          ' (parent of inactive configuration for ' << hooked_instance.name.to_s << ')'
          end
          unless fail_string
            if instance_configuration.parent.nil?
              fail_string = 'inactive configuration :' << instance_configuration.name.to_s << ' for ' << 
                            hooked_instance.name.to_s << ' did not have expected parent ' << parent_instance.name.to_s << 
                            ' (had nil)'
            end
          end
        end
      end
    end
    





    configuration_method_name = '•' << name.to_s

    # * should have methods
    unless fail_string or ! has_methods
      unless hooked_instance.respond_to?( configuration_method_name.to_s )
        fail_string = hooked_instance.name.to_s << ' did not respond to :' << configuration_method_name.to_s
      end
      unless fail_string or
             hooked_instance.__send__( configuration_method_name.to_s ).equal?( singleton_configuration )
        fail_string = 'configuration returned by configuration instance getter (:' << configuration_method_name.to_s <<
                      ') did not match configuration belonging to ' << hooked_instance.to_s
      end
      unless fail_string or
             hooked_instance.respond_to?( name.to_s )
        fail_string = hooked_instance.name.to_s << ' did not respond to configuration value getter:' << name.to_s
      end
      unless fail_string or
             hooked_instance.respond_to?( write_name.to_s )
        fail_string = hooked_instance.name.to_s << ' did not respond to configuration value setter:' << write_name.to_s
      end
    end

    # * should have instance methods
    unless fail_string or ! has_instance_methods
      unless hooked_instance.method_defined?( configuration_method_name )
        fail_string = hooked_instance.name.to_s << ' did not define instance method :' << 
                      configuration_method_name.to_s
      end
      unless fail_string or
             hooked_instance.method_defined?( name )
        fail_string = hooked_instance.name.to_s << ' did not define instance method configuration ' <<
                      'value getter:' << name.to_s
      end
      unless fail_string or
             hooked_instance.method_defined?( name )
        fail_string = hooked_instance.name.to_s << ' did not define instance method configuration ' <<
                      'value setter:' << write_name.to_s
      end
    end

    fail_string ? false : true

  end

  failure_message_for_should { fail_string }
  failure_message_for_should_not { unexpected_success_string }

end
