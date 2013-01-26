
RSpec::Matchers.define :have_defined_configuration do |base_name, alias_names, configuration_type, ccm|

  fail_string = nil
  unexpected_success_string = nil

  ##############
  #  test_ccm  #
  ##############

  def test_ccm( instance, include_or_extend, base_name, configuration_type, ccm, & block )

    fail_string = nil
    
    instance.module_eval { __send__( include_or_extend, ccm ) }
    
    instance.__send__( base_name, :configuration_name )    
    instance.__send__( base_name, :configuration_name? => :__configuration_name__= )

    should_respond = nil
    should_be_defined = nil

    case configuration_type
      when :all
        should_respond = true
        should_be_defined = true
        case include_or_extend
          when :include
            should_cascade_singleton = true
            should_cascade_instance = true
          when :extend
            should_cascade_singleton = true
            should_cascade_instance = false
        end
      when :singleton, :module, :class
        should_respond = true
        should_be_defined = false
        case include_or_extend
          when :include
            should_cascade_singleton = true
            should_cascade_instance = false
          when :extend
            should_cascade_singleton = true
            should_cascade_instance = false
        end
      when :instance
        should_respond = false
        should_be_defined = true
        case include_or_extend
          when :include
            should_cascade_singleton = false
            should_cascade_instance = true
          when :extend
            should_cascade_singleton = false
            should_cascade_instance = false
        end
      when :local_instance
        should_respond = true
        should_be_defined = true
        should_cascade_singleton = false
        should_cascade_instance = false
      when :object
        should_respond = true
        should_be_defined = false
        should_cascade_singleton = false
        should_cascade_instance = false
    end

    case instance
      when ::Class
        # base class
        base_class = instance
        test_respond( base_class, nil, 'base class', & block ) if should_respond
        test_defined( base_class, nil, 'base class', & block ) if should_be_defined
        # first subclass
        first_subclass = ::Class.new( base_class )
        test_respond( first_subclass, base_class, 'first subclass', & block ) if should_cascade_singleton
        test_defined( first_subclass, base_class, 'first subclass', & block ) if should_cascade_instance
        # nth subclass
        nth_subclass = ::Class.new( first_subclass )
        test_respond( nth_subclass, first_subclass, 'nth subclass', & block ) if should_cascade_singleton
        test_defined( nth_subclass, first_subclass, 'nth subclass', & block ) if should_cascade_instance
      when ::Module
        # base module
        base_module = instance
        test_respond( base_module, nil, 'base module', & block ) if should_respond
        test_defined( base_module, nil, 'base module', & block ) if should_be_defined
        # first sub-module
        first_submodule = ::Module.new { include( base_module ) }
        test_respond( first_submodule, base_module, 'first sub-module', & block ) if should_cascade_singleton
        test_defined( first_submodule, base_module, 'first sub-module', & block ) if should_cascade_instance
        # nth sub-module
        nth_submodule = ::Module.new { include( first_submodule ) }
        test_respond( nth_submodule, first_submodule, 'nth sub-module', & block ) if should_cascade_singleton
        test_defined( nth_submodule, first_submodule, 'nth sub-module', & block ) if should_cascade_instance
        # first class
        first_class = ::Class.new { include( nth_submodule ) }
        test_respond( first_class, nth_submodule, 'first class', & block ) if should_cascade_singleton
        test_defined( first_class, nth_submodule, 'first class', & block ) if should_cascade_instance
        # first subclass
        first_subclass = ::Class.new( first_class )
        test_respond( first_subclass, first_class, 'first subclass', & block ) if should_cascade_singleton
        test_defined( first_subclass, first_class, 'first subclass', & block ) if should_cascade_instance
        # nth subclass
        nth_subclass = ::Class.new( first_subclass )
        test_respond( nth_subclass, first_subclass, 'nth subclass', & block ) if should_cascade_instance
    end
    
    return fail_string
    
  end
  
  ##################
  #  test_respond  #
  ##################
  
  def test_respond( instance, parent_instance, descriptor, & block )
    
    fail_string = nil
    
    unless instance.respond_to?( :configuration_name )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define singleton getter on ' << descriptor.to_s << 
                    ' where reader/writer is based on configuration name.'
    end
    unless fail_string or instance.respond_to?( :configuration_name= )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define singleton setter on ' << descriptor.to_s << 
                    ' where reader/writer is based on configuration name.'
    end
    unless fail_string or instance.respond_to?( :configuration_name? )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define singleton getter on ' << descriptor.to_s << 
                    ' where reader/writer is based on hash pair.'
    end
    unless fail_string or instance.respond_to?( :__configuration_name__= )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define singleton setter on ' << descriptor.to_s << 
                    ' where reader/writer is based on hash pair.'
    end
    
    if block_given?
      fail_string = instance.instance_exec( configuration_instance, 
                                            parent_instance, 
                                            configuration_module, 
                                            include_or_extend, 
                                            configuration_type, 
                                            configuration, 
                                            & block )
    end
    
    return fail_string
    
  end
  
  ##################
  #  test_defined  #
  ##################

  def test_defined( instance, parent_instance, descriptor )
    
    fail_string = nil
    
    unless fail_string or instance.method_defined?( :configuration_name )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define getter on ' << descriptor.to_s << 
                    ' where reader/writer is based on configuration name.'
    end
    unless fail_string or instance.method_defined?( :configuration_name= )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define setter  ' << descriptor.to_s << 
                    ' where reader/writer is based on configuration name.'
    end
    unless fail_string or instance.method_defined?( :configuration_name? )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define getter  ' << descriptor.to_s << 
                    ' where reader/writer is based on hash pair.'
    end
    unless fail_string or instance.method_defined?( :__configuration_name__= )
      fail_string = 'configuration definer for type :' << configuration_type.to_s << 
                    ' did not define setter  ' << descriptor.to_s << 
                    ' where reader/writer is based on hash pair.'
    end
    
    if block_given?
      fail_string = instance.instance_exec( configuration_instance, 
                                            parent_instance, 
                                            configuration_module, 
                                            include_or_extend, 
                                            configuration_type, 
                                            configuration, 
                                            & block )
    end
    
    return fail_string
    
  end

  ###########
  #  match  #
  ###########
  
  match do |configuration_module, & block| 
    
    unexpected_success_string = 'configuration was defined for ' << ( instance.name || instance ).to_s << 
                                ' with base name :' << base_name.to_s << ' and alias names :' << 
                                alias_names.collect( & :to_s ).join( ', :' ) << ' but was not expected to be defined.'

    unless instance.method_defined?( base_name )
      fail_string = 'base method :' << base_name.to_s << ' was not defined for ' << 
                    ( instance.name || instance ).to_s << '.'
    end
        
    unless fail_string
      alias_names.each do |this_alias_name|
        unless instance.method_defined?( this_alias_name )
          fail_string = 'alias :' << this_alias_name.to_s << ' was not defined for base method :' << base_name.to_s <<
                        ' for ' << ( instance.name || instance ).to_s << '.'
          break
        end
        unless instance.instance_method( base_name ) == instance.instance_method( this_alias_name )
          fail_string = 'method for alias :' << this_alias_name.to_s << ' (' << 
                        instance.instance_method( this_alias_name ).to_s << ') was not equivalent to base method :' << 
                        base_name.to_s << ' (' << instance.instance_method( base_name ).to_s << ') for ' << 
                        ( instance.name || instance ).to_s << '.'
          break
        end
      end
    end
    
    # include ccm in a module
    unless fail_string
      fail_string = test_ccm( ::Module.new.name( :CCMIncludedModule ), :include, base_name, configuration_type, ccm )
    end
    # extend module with ccm
    unless fail_string
      fail_string = test_ccm( ::Module.new.name( :CCMExtendedModule ), :extend, base_name, configuration_type, ccm )
    end

    # include ccm in a class
    unless fail_string
      fail_string = test_ccm( ::Class.new.name( :CCMIncludedClass ), :include, base_name, configuration_type, ccm )
    end
    # extend class with ccm
    unless fail_string
      fail_string = test_ccm( ::Class.new.name( :CCMExtendedClass ), :extend, base_name, configuration_type, ccm )
    end
    
    matched = ! fail_string

  end

  failure_message_for_should { fail_string }
  failure_message_for_should_not { unexpected_success_string }

end
