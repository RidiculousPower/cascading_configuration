
require_relative '../../../lib/cascading_configuration.rb'

describe CascadingConfiguration::Array::Unique do
    
  #######################
  #  attr_unique_array  #
  #######################
  
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
    module ::CascadingConfiguration::Array::Unique::ConfigurationMockModuleExtended
      extend CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_unique_array ).should == true
      respond_to?( :attr_configuration_unique_array ).should == true
      attr_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded
      include CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_unique_array ).should == true
      attr_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :another_configuration )
        configuration_setting.push( :another_configuration )
        configuration_setting.should == [ :a_configuration, :another_configuration ]
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == [ :a_configuration ]
        configuration_setting.push( :some_other_configuration )
        configuration_setting.push( :some_other_configuration )
        configuration_setting.push( :some_other_configuration )
        configuration_setting.should == [ :a_configuration, :some_other_configuration ]
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded
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
        extend CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded
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

    class CascadingConfiguration::Array::Unique::ConfigurationMockClass
      include CascadingConfiguration::Array::Unique::ConfigurationMockModuleIncluded::SubmoduleIncluding
      configuration_setting.should == [ :a_configuration, :another_configuration ]
      configuration_setting.push( :some_other_configuration )
      configuration_setting.push( :some_other_configuration )
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::Unique::ConfigurationMockClass.new
    object_instance_one.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.configuration_setting.delete( :a_configuration )
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration ]
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1 < CascadingConfiguration::Array::Unique::ConfigurationMockClass
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      configuration_setting.delete( :a_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1.new
    object_instance_two.configuration_setting.should == [ :another_configuration, :some_other_configuration ]
    object_instance_two.configuration_setting.delete( :another_configuration )
    object_instance_two.configuration_setting.should == [ :some_other_configuration ]
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ConfigurationMockClassSub2 < CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      #configuration_setting.push( :yet_another_configuration )
      #configuration_setting.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::Array::Unique::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::Array::Unique::ConfigurationMockClass.configuration_setting.push( :a_yet_unused_configuration )
    CascadingConfiguration::Array::Unique::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.configuration_setting.should == [ :some_other_configuration, :a_yet_unused_configuration ]
    
    # freeze ancestor setting
    object_instance_one.configuration_setting.freeze!
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ConfigurationMockClass.configuration_setting.push( :non_cascading_configuration )
    CascadingConfiguration::Array::Unique::ConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration, :non_cascading_configuration ]
    object_instance_one.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.configuration_setting.should == [ :some_other_configuration, :a_yet_unused_configuration ]
        
  end

  ##############################
  #  attr_module_unique_array  #
  #  attr_class_unique_array   #
  ##############################
  
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
    module ::CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleExtended
      extend CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_configuration_unique_array ).should == true
      respond_to?( :attr_module_unique_array ).should == true
      method( :attr_module_unique_array ).should == method( :attr_class_unique_array )
      attr_module_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded
      include CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_unique_array ).should == true
      attr_module_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded
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
        extend CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded
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
        extend CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::Unique::ClassConfigurationMockClass
      include CascadingConfiguration::Array::Unique::ClassConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :a_configuration, :another_configuration ]
      configuration_setting.push( :some_other_configuration )
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1 < CascadingConfiguration::Array::Unique::ClassConfigurationMockClass
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      configuration_setting.delete( :a_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub2 < CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == [ :another_configuration, :some_other_configuration ]
      configuration_setting.push( :yet_another_configuration )
      configuration_setting.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.configuration_setting.push( :a_yet_unused_configuration )
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    
    # freeze ancestor setting
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.configuration_setting.push( :non_cascading_configuration )
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClass.configuration_setting.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration, :non_cascading_configuration ]
    CascadingConfiguration::Array::Unique::ClassConfigurationMockClassSub1.configuration_setting.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
        
  end
  
  #############################
  #  attr_local_unique_array  #
  #############################
  
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
    module ::CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleExtended
      extend CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_configuration_unique_array ).should == true
      respond_to?( :attr_local_unique_array ).should == true
      attr_local_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded
      include CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_unique_array ).should == true
      attr_local_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::Unique::LocalConfigurationMockClass
      include CascadingConfiguration::Array::Unique::LocalConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::Unique::LocalConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::LocalConfigurationMockClassSub1 < CascadingConfiguration::Array::Unique::LocalConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::Unique::LocalConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::LocalConfigurationMockClassSub2 < CascadingConfiguration::Array::Unique::LocalConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end
  
  ################################
  #  attr_instance_unique_array  #
  ################################
  
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
    module ::CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleExtended
      extend CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded
      include CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_instance_unique_array ).should == true
      attr_instance_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == false
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::Unique::InstanceConfigurationMockClass
      include CascadingConfiguration::Array::Unique::InstanceConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::Unique::InstanceConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::InstanceConfigurationMockClassSub1 < CascadingConfiguration::Array::Unique::InstanceConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::Unique::InstanceConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::InstanceConfigurationMockClassSub2 < CascadingConfiguration::Array::Unique::InstanceConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end
  
  
  ##############################
  #  attr_object_unique_array  #
  ##############################
  
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
    module ::CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleExtended
      extend CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_configuration_unique_array ).should == true
      respond_to?( :attr_object_unique_array ).should == true
      attr_object_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded
      include CascadingConfiguration::Array::Unique
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_unique_array ).should == true
      attr_object_unique_array :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == false
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Array::Unique::ObjectConfigurationMockClass
      include CascadingConfiguration::Array::Unique::ObjectConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::Array::Unique::ObjectConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ObjectConfigurationMockClassSub1 < CascadingConfiguration::Array::Unique::ObjectConfigurationMockClass
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::Array::Unique::ObjectConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::Array::Unique::ObjectConfigurationMockClassSub2 < CascadingConfiguration::Array::Unique::ObjectConfigurationMockClassSub1
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end
        
  end
  
end
