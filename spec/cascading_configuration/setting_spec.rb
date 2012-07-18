
require_relative '../../lib/cascading_configuration.rb'

describe CascadingConfiguration::Setting do

  ##################
  #  attr_setting  #
  ##################
  
  it 'can define a configuration setting, which is the primary interface' do

    # extending a module or class works like a finalizer for the cascading configuration
    # if the configuration is re-opened at a later point (including or extending a lower ancestor)
    # then the configuration will still cascade upward
    # this permits ancestors in the heirarchy to skip out on configurations
    # upward cascade can be frozen at any point using :freeze!, which will prevent further upward lookup

    # possibilities:
    # * module extended with setting
    module ::CascadingConfiguration::Setting::ConfigurationMockExtended
      extend CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_setting ).should == true
      respond_to?( :attr_configuration ).should == true
      attr_setting :some_configuration, :some_other_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Setting::ConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Setting::ConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Setting::ConfigurationMockIncluded
      include CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      eigenclass = class << self ; self ; end
      respond_to?( :attr_setting ).should == true
      attr_setting :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :another_configuration
        some_configuration.should == :another_configuration
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ConfigurationMockIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :some_other_configuration
        some_configuration.should == :some_other_configuration
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Setting::ConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :another_configuration
        some_configuration.should == :another_configuration
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == true
      setting_class_including_instance.some_configuration.should == :another_configuration
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Setting::ConfigurationMockIncluded
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :some_other_configuration
        some_configuration.should == :some_other_configuration
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Setting::ConfigurationMockClass
      include CascadingConfiguration::Setting::ConfigurationMockIncluded::SubmoduleIncluding
      respond_to?( :some_configuration ).should == true
      some_configuration.should == :another_configuration
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ConfigurationMockClassSub1 < CascadingConfiguration::Setting::ConfigurationMockClass
      some_configuration.should == :our_setting_value
      self.some_configuration = :our_other_setting_value
      some_configuration.should == :our_other_setting_value
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ConfigurationMockClassSub2 < CascadingConfiguration::Setting::ConfigurationMockClassSub1
      some_configuration.should == :our_other_setting_value
      self.some_configuration = :a_third_setting_value
      some_configuration.should == :a_third_setting_value
      instance_variables.empty?.should == true
    end

    module SomeModule
      include CascadingConfiguration::Setting
      attr_setting :some_configuration
      self.some_configuration = :another_configuration
    end
    module OtherModule
      include SomeModule
    end
    Object.new.instance_eval do
      extend( OtherModule )
      respond_to?( :some_configuration ).should == true
      some_configuration.should == :another_configuration
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      instance_variables.empty?.should == true
    end
    
  end
  
  #########################
  #  attr_module_setting  #
  #  attr_class_setting   #
  #########################
  
  it 'can define a class configuration setting, which will not cascade to instances' do

    # extending a module or class works like a finalizer for the cascading configuration
    # if the configuration is re-opened at a later point (including or extending a lower ancestor)
    # then the configuration will still cascade upward
    # this permits ancestors in the hierarchy to skip out on configurations
    # upward cascade can be frozen at any point using :freeze!, which will prevent further upward lookup

    # possibilities:
    # * module extended with setting
    module ::CascadingConfiguration::Setting::ClassConfigurationMockExtended
      extend CascadingConfiguration::Setting
      # => singleton gets attr_module_configuration and configurations
      respond_to?( :attr_module_setting ).should == true
      respond_to?( :attr_module_configuration ).should == true
      method( :attr_module_configuration ).should == method( :attr_class_configuration )
      attr_module_configuration :some_configuration
      respond_to?( :attr_module_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ClassConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ClassConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Setting::ClassConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Setting::ClassConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Setting::ClassConfigurationMockIncluded
      include CascadingConfiguration::Setting
      # => singleton gets attr_module_configuration and configurations
      respond_to?( :attr_module_configuration ).should == true
      attr_module_configuration :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_module_configuration and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ClassConfigurationMockIncluded
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :another_configuration
        some_configuration.should == :another_configuration
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_module_configuration and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ClassConfigurationMockIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Setting::ClassConfigurationMockIncluded
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == true
        some_configuration.should == :our_setting_value
        self.some_configuration = :another_configuration
        some_configuration.should == :another_configuration
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Setting::ClassConfigurationMockIncluded
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Setting::ClassConfigurationMockClass
      include CascadingConfiguration::Setting::ClassConfigurationMockIncluded::SubmoduleIncluding
      respond_to?( :some_configuration ).should == true
      some_configuration.should == :another_configuration
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ClassConfigurationMockClassSub1 < CascadingConfiguration::Setting::ClassConfigurationMockClass
      some_configuration.should == :our_setting_value
      self.some_configuration = :our_other_setting_value
      some_configuration.should == :our_other_setting_value
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ClassConfigurationMockClassSub2 < CascadingConfiguration::Setting::ClassConfigurationMockClassSub1
      some_configuration.should == :our_other_setting_value
      self.some_configuration = :a_third_setting_value
      some_configuration.should == :a_third_setting_value
      instance_variables.empty?.should == true
    end
    
  end
  
  ########################
  #  attr_local_setting  #
  ########################
  
  it 'can define a local configuration setting, which cascades to the first class and instances' do

    # extending a module or class works like a finalizer for the cascading configuration
    # if the configuration is re-opened at a later point (including or extending a lower ancestor)
    # then the configuration will still cascade upward
    # this permits ancestors in the heirarchy to skip out on configurations
    # upward cascade can be frozen at any point using :freeze!, which will prevent further upward lookup

    # possibilities:
    # * module extended with setting
    module ::CascadingConfiguration::Setting::LocalConfigurationMockExtended
      extend CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_setting ).should == true
      respond_to?( :attr_local_configuration ).should == true
      attr_local_configuration :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
    end
  
    # * module included with setting
    module ::CascadingConfiguration::Setting::LocalConfigurationMockIncluded
      include CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_configuration ).should == true
      attr_local_configuration :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      module SubSubmoduleIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubmoduleIncluding
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      module SubSubmoduleExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubmoduleExtending
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockIncluded
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassSubSubmoduleIncludingIncluding
        include CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubSubmoduleIncluding
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassSubSubmoduleIncludingIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassSubSubmoduleIncludingExtending
        extend CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubSubmoduleIncluding
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassSubSubmoduleIncludingExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassSubSubmoduleIncludingIncludingAndExtending
        include CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubSubmoduleIncluding
        extend CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubSubmoduleIncluding
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassSubSubmoduleIncludingIncludingAndExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Setting::LocalConfigurationMockClass
      include CascadingConfiguration::Setting::LocalConfigurationMockIncluded::SubmoduleIncluding
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::LocalConfigurationMockClassSub1 < CascadingConfiguration::Setting::LocalConfigurationMockClass
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::LocalConfigurationMockClassSub2 < CascadingConfiguration::Setting::LocalConfigurationMockClassSub1
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
  end

  ###########################
  #  attr_instance_setting  #
  ###########################
  
  it 'can define a configuration setting for the present instance, which will not cascade' do

    # possibilities:
    # * module extended with setting
    module ::CascadingConfiguration::Setting::InstanceConfigurationMockExtended
      extend CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_instance_setting ).should == true
      respond_to?( :attr_instance_configuration ).should == true
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::InstanceConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::InstanceConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Setting::InstanceConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Setting::InstanceConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
    end
  
    # * module included with setting
    module ::CascadingConfiguration::Setting::InstanceConfigurationMockIncluded
      include CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_instance_configuration ).should == true
      respond_to?( :some_configuration ).should == false
      attr_instance_configuration :some_configuration
      respond_to?( :some_configuration ).should == false
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::InstanceConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::InstanceConfigurationMockIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Setting::InstanceConfigurationMockIncluded
        method_defined?( :some_configuration ).should == true
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Setting::InstanceConfigurationMockIncluded
        respond_to?( :some_configuration ).should == true
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Setting::InstanceConfigurationMockClass
      include CascadingConfiguration::Setting::InstanceConfigurationMockIncluded::SubmoduleIncluding
      respond_to?( :some_configuration ).should == false
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::InstanceConfigurationMockClassSub1 < CascadingConfiguration::Setting::InstanceConfigurationMockClass
      respond_to?( :some_configuration ).should == false
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::InstanceConfigurationMockClassSub2 < CascadingConfiguration::Setting::InstanceConfigurationMockClassSub1
      respond_to?( :some_configuration ).should == false
      method_defined?( :some_configuration ).should == true
      instance_variables.empty?.should == true
    end
  end
  
  #########################
  #  attr_object_setting  #
  #########################
  
  it 'can define a configuration setting for the present instance, which will not cascade' do

    # possibilities:
    # * module extended with setting
    module ::CascadingConfiguration::Setting::ObjectConfigurationMockExtended
      extend CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_setting ).should == true
      respond_to?( :attr_object_configuration ).should == true
      attr_object_configuration :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ObjectConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ObjectConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Setting::ObjectConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Setting::ObjectConfigurationMockExtended
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
    end
  
    # * module included with setting
    module ::CascadingConfiguration::Setting::ObjectConfigurationMockIncluded
      include CascadingConfiguration::Setting
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_configuration ).should == true
      attr_object_configuration :some_configuration
      respond_to?( :some_configuration ).should == true
      self.some_configuration = :our_setting_value
      some_configuration.should == :our_setting_value
      method_defined?( :some_configuration ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Setting::ObjectConfigurationMockIncluded
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Setting::ObjectConfigurationMockIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Setting::ObjectConfigurationMockIncluded
        method_defined?( :some_configuration ).should == false
        respond_to?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::Setting::ObjectConfigurationMockIncluded
        respond_to?( :some_configuration ).should == false
        method_defined?( :some_configuration ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_configuration ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Setting::ObjectConfigurationMockClass
      include CascadingConfiguration::Setting::ObjectConfigurationMockIncluded::SubmoduleIncluding
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ObjectConfigurationMockClassSub1 < CascadingConfiguration::Setting::ObjectConfigurationMockClass
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
    class CascadingConfiguration::Setting::ObjectConfigurationMockClassSub2 < CascadingConfiguration::Setting::ObjectConfigurationMockClassSub1
      respond_to?( :some_configuration ).should == false
      instance_variables.empty?.should == true
    end
  end
    
end
