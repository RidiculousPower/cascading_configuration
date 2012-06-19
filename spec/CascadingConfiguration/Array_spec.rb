
require_relative '../../lib/cascading-configuration.rb'

describe CascadingConfiguration::Array do
    
  ################
  #  attr_array  #
  ################
  
  it 'can define a configuration array, which is the primary interface' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get attr_setting and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_setting and configurations
    # => instances of extending classes get nothing
    module ::CascadingConfiguration::Array::ConfigurationMockModuleExtended
      extend CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_array ).should == true
      respond_to?( :attr_configuration_array ).should == true
      attr_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::ConfigurationMockModuleIncluded
      include CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_array ).should == true
      attr_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :another_configuration )
        configuration_setting.should == [ :a_configuration, :another_configuration ]
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::ConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.configuration_setting.should == [ :a_configuration, :some_other_configuration ]
      setting_class_including_instance.configuration_setting.delete( :some_other_configuration )
      setting_class_including_instance.configuration_setting = [ :our_setting_value ]
      setting_class_including_instance.configuration_setting.should == [ :our_setting_value ]
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::ConfigurationMockModuleIncluded
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::ConfigurationMockClass
      include CascadingConfiguration::Array::ConfigurationMockModuleIncluded::SubmoduleIncluding
      configuration_setting.should == [ :a_configuration, :another_configuration ]
      configuration_setting.push( :some_other_configuration )
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::ConfigurationMockClass.new
    object_instance_one.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.configuration_setting.delete( :a_configuration )
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration ]
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ConfigurationMockClassSub1 < CascadingConfiguration::Array::ConfigurationMockClass
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      configuration_setting.delete( :a_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::ConfigurationMockClassSub1.new
    object_instance_two.configuration_setting.should == [ :another_configuration, :some_other_configuration ]
    object_instance_two.configuration_setting.delete( :another_configuration )
    object_instance_two.configuration_setting.should == [ :some_other_configuration ]
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ConfigurationMockClassSub2 < CascadingConfiguration::Array::ConfigurationMockClassSub1
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      #configuration_setting.push( :yet_another_configuration )
      #configuration_setting.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::Array::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::Array::ConfigurationMockClass.configuration_setting.push( :a_yet_unused_configuration )
    CascadingConfiguration::Array::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.configuration_setting.should == [ :some_other_configuration, :a_yet_unused_configuration ]
    
    # freeze ancestor setting
    object_instance_one.configuration_setting.freeze!
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Array::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ConfigurationMockClass.configuration_setting.push( :non_cascading_configuration )
    CascadingConfiguration::Array::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration, :non_cascading_configuration ]
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.configuration_setting.should == [ :some_other_configuration, :a_yet_unused_configuration ]
        
  end

  #######################
  #  attr_module_array  #
  #  attr_class_array   #
  #######################
  
  it 'can define a class configuration array, which will not cascade to instances' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get attr_setting and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_setting and configurations
    # => instances of extending classes get nothing
    module ::CascadingConfiguration::Array::ClassConfigurationMockModuleExtended
      extend CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_configuration_array ).should == true
      respond_to?( :attr_module_array ).should == true
      method( :attr_module_array ).should == method( :attr_class_array )
      attr_module_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded
      include CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_array ).should == true
      attr_module_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :another_configuration )
        configuration_setting.should == [ :a_configuration, :another_configuration ]
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::ClassConfigurationMockClass
      include CascadingConfiguration::Array::ClassConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :a_configuration, :another_configuration ]
      configuration_setting.push( :some_other_configuration )
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::ClassConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ClassConfigurationMockClassSub1 < CascadingConfiguration::Array::ClassConfigurationMockClass
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      configuration_setting.delete( :a_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::ClassConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ClassConfigurationMockClassSub2 < CascadingConfiguration::Array::ClassConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      configuration_setting.push( :yet_another_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::Array::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::Array::ClassConfigurationMockClass.configuration_setting.push( :a_yet_unused_configuration )
    CascadingConfiguration::Array::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    
    # freeze ancestor setting
    CascadingConfiguration::Array::ClassConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Array::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::ClassConfigurationMockClass.configuration_setting.push( :non_cascading_configuration )
    CascadingConfiguration::Array::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration, :non_cascading_configuration ]
    CascadingConfiguration::Array::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
        
  end
  
  ######################
  #  attr_local_array  #
  ######################
  
  it 'can define a local configuration array, which will not cascade' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get attr_setting and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_setting and configurations
    # => instances of extending classes get nothing
    module ::CascadingConfiguration::Array::LocalConfigurationMockModuleExtended
      extend CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_configuration_array ).should == true
      respond_to?( :attr_local_array ).should == true
      attr_local_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded
      include CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_array ).should == true
      attr_local_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::LocalConfigurationMockClass
      include CascadingConfiguration::Array::LocalConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::LocalConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::LocalConfigurationMockClassSub1 < CascadingConfiguration::Array::LocalConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::LocalConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::LocalConfigurationMockClassSub2 < CascadingConfiguration::Array::LocalConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end
  
  #########################
  #  attr_instance_array  #
  #########################
  
  it 'can define an instance configuration array, which will not cascade' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get attr_setting and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_setting and configurations
    # => instances of extending classes get nothing
    module ::CascadingConfiguration::Array::InstanceConfigurationMockModuleExtended
      extend CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded
      include CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_instance_array ).should == true
      attr_instance_array :configuration_setting
      respond_to?( :configuration_setting ).should == false
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::InstanceConfigurationMockClass
      include CascadingConfiguration::Array::InstanceConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::InstanceConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::InstanceConfigurationMockClassSub1 < CascadingConfiguration::Array::InstanceConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::InstanceConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::InstanceConfigurationMockClassSub2 < CascadingConfiguration::Array::InstanceConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end
  
  
  #######################
  #  attr_object_array  #
  #######################
  
  it 'can define an object configuration array, which will not cascade' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_setting and configurations
    # => including modules and classes get attr_setting and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_setting and configurations
    # => instances of extending classes get nothing
    module ::CascadingConfiguration::Array::ObjectConfigurationMockModuleExtended
      extend CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_configuration_array ).should == true
      respond_to?( :attr_object_array ).should == true
      attr_object_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded
      include CascadingConfiguration::Array
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_array ).should == true
      attr_object_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::ObjectConfigurationMockClass
      include CascadingConfiguration::Array::ObjectConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::ObjectConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ObjectConfigurationMockClassSub1 < CascadingConfiguration::Array::ObjectConfigurationMockClass
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::ObjectConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::ObjectConfigurationMockClassSub2 < CascadingConfiguration::Array::ObjectConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end

  ###########################
  #  attr_array with hooks  #
  ###########################
  
  it 'can define a configuration array with hooks' do
    module ::CascadingConfiguration::Array::HooksMock
      include ::CascadingConfiguration::Array
      module ExtensionModule
        def push( arg )
          super( 2 )
        end
      end
      attr_array :configuration_setting, ExtensionModule
      configuration_setting.push( 1 )
      configuration_setting[ 0 ].should == 2
      attr_array :other_configuration_setting do
        def push( arg )
          super( 2 )
        end
      end
      other_configuration_setting.is_a?( Controller::Default_other_configuration_setting ).should == true
      other_configuration_setting.push( 1 )
      other_configuration_setting[ 0 ].should == 2
    end
  end
  
end
