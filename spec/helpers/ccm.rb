# -*- encoding : utf-8 -*-

RSpec::Matchers.define :have_cascaded do |parent_instance, name, write_name, has_methods, has_instance_methods, should_cascade_hook|

  fail_string = nil
  unexpected_success_string = nil

  match do |hooked_instance| 

    unexpected_success_string = 'configuration cascaded to ' << hooked_instance.to_s << 
                                ' but was not expected to do so.'

    # * should have cascaded hook
    if should_cascade_hook
      unless ::Module::Cluster === hooked_instance and
             hooked_instance.has_cluster?( :cascading_configuration_inheritance ) ||
             ::Class === parent_instance
        fail_string = 'inheritance hook did not cascade to ' << hooked_instance.name.to_s
      end
    end

    # * should have configuration
    configuration = nil
    unless fail_string
      configuration = has_methods ? ::CascadingConfiguration.configuration( hooked_instance, name, false )
                                  : ::CascadingConfiguration.instance_configuration( hooked_instance, name, false )
      unless configuration
        fail_string = 'configuration was not created for ' << hooked_instance.name.to_s
      end
    end
    
    # * should have methods
    configuration_method_name = '•' << name.to_s
    if has_methods
      unless fail_string or
             hooked_instance.respond_to?( configuration_method_name.to_s )
        fail_string = hooked_instance.name.to_s << ' did not respond to :' << configuration_method_name.to_s
      end
      unless fail_string or
             hooked_instance.__send__( configuration_method_name.to_s ).equal?( configuration )
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
    if has_instance_methods
      unless fail_string
        case hooked_instance
          when ::Module
            unless hooked_instance.method_defined?( configuration_method_name )
              fail_string = hooked_instance.name.to_s << ' did not define instance method :' << 
                            configuration_method_name.to_s
            end
          else
            unless hooked_instance.respond_to?( configuration_method_name )
              fail_string = hooked_instance.name.to_s << ' did not respond to instance method :' << 
                            configuration_method_name.to_s
            end
        end
      end
      unless fail_string
        case hooked_instance
          when ::Module
            unless hooked_instance.method_defined?( name )
              fail_string = hooked_instance.name.to_s << ' did not define instance method configuration ' <<
                            'value getter:' << name.to_s
            end
          else
            unless hooked_instance.respond_to?( name )
              fail_string = hooked_instance.name.to_s << ' did not respond to instance method configuration ' <<
                            'value getter:' << name.to_s
            end
        end
      end
      unless fail_string
        case hooked_instance
          when ::Module
            unless hooked_instance.method_defined?( name )
              fail_string = hooked_instance.name.to_s << ' did not define instance method configuration ' <<
                            'value setter:' << write_name.to_s
            end
          else
            unless hooked_instance.respond_to?( name )
              fail_string = hooked_instance.name.to_s << ' did not respond to instance method configuration ' <<
                            'value setter:' << write_name.to_s
            end
        end
      end
    end

    # * configuration parent should be prior
    if parent_instance
      parent_configuration = ::CascadingConfiguration.configuration( parent_instance, name, false ) ||
                             ::CascadingConfiguration.instance_configuration( parent_instance, name, false )
      unless ::CascadingConfiguration::InactiveConfiguration === parent_configuration or
             ::CascadingConfiguration::InactiveConfiguration === configuration
        unless fail_string
          if configuration.parent.nil?
            fail_string = 'configuration :' << name.to_s << ' for ' << hooked_instance.name.to_s <<
                          ' did not have expected parent ' << parent_instance.name.to_s << ' (had nil)'
          end
        end
        unless fail_string
          unless parent_configuration
            fail_string = 'configuration did not exist for ' << parent_instance.name.to_s << ' (parent of ' << 
                          hooked_instance.name.to_s << ')'
          end
        end
        unless fail_string or
               configuration.parent.equal?( parent_configuration )
          fail_string = 'parent configuration for ' << hooked_instance.name.to_s << ' did not belong to ' << 
                        parent_instance.name.to_s << ' (belongs to ' << configuration.parent.instance.name.to_s << ')'
        end
      end
    end

    fail_string ? false : true

  end

  failure_message_for_should { fail_string }
  failure_message_for_should_not { unexpected_success_string }

end
