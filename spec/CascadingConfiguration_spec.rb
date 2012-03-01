
require_relative '../lib/cascading-configuration.rb'

describe CascadingConfiguration do
  
  ########################
  #  attr_configuration  #
  ########################
  
  it 'can declare an attribute as a cascading configuration setting' do

    # first module
    module CascadingConfiguration::MockModule
      include CascadingConfiguration
      attr_configuration :some_configuration
      self.some_configuration = :some_value
      some_configuration.should == :some_value
    end

    # including module 1
    module CascadingConfiguration::MockModule2
      include CascadingConfiguration::MockModule
      some_configuration.should == :some_value
      self.some_configuration = :module_value
      some_configuration.should == :module_value
    end

    # including module 2
    module CascadingConfiguration::MockModule3
      include CascadingConfiguration::MockModule2
    end

    # top class
    class CascadingConfiguration::MockClass
      include CascadingConfiguration::MockModule3
      some_configuration.should == :module_value
      self.some_configuration = :another_value
      some_configuration.should == :another_value
    end

    # instance of top class
    object_instance_one = CascadingConfiguration::MockClass.new
    object_instance_one.some_configuration.should == :another_value
    object_instance_one.some_configuration = :yet_another_value
    object_instance_one.some_configuration.should == :yet_another_value
    CascadingConfiguration::MockClass.some_configuration.should == :another_value
    CascadingConfiguration::MockModule.some_configuration.should == :some_value

    # first inheriting class
    class CascadingConfiguration::MockClassSub1 < CascadingConfiguration::MockClass
      some_configuration.should == :another_value
      self.some_configuration = :a_value_not_yet_used
      some_configuration.should == :a_value_not_yet_used
      CascadingConfiguration::MockClass.some_configuration.should == :another_value
      CascadingConfiguration::MockModule.some_configuration.should == :some_value
    end

    # Instance of First Inheriting Class
    object_instance_two = CascadingConfiguration::MockClassSub1.new
    object_instance_two.some_configuration.should == :a_value_not_yet_used
    object_instance_one.some_configuration.should == :yet_another_value
    CascadingConfiguration::MockClass.some_configuration.should == :another_value
    CascadingConfiguration::MockModule.some_configuration.should == :some_value

    # Second Inheriting Class
    class CascadingConfiguration::MockClassSub2 < CascadingConfiguration::MockClassSub1
      some_configuration.should == :a_value_not_yet_used
      self.some_configuration = :another_value_not_yet_used
      some_configuration.should == :another_value_not_yet_used
    end

    # Instance of Second Inheriting Class
    object_instance_three = CascadingConfiguration::MockClassSub2.new
    object_instance_three.some_configuration.should == :another_value_not_yet_used
    object_instance_three.some_configuration = :one_more_unused_value
    object_instance_three.some_configuration.should == :one_more_unused_value

  end

  ##############################
  #  attr_configuration_array  #
  ##############################
  
  it 'can declare an attribute as a cascading configuration array' do

    # first module
    module CascadingConfiguration::MockModule
      include CascadingConfiguration
      attr_configuration_array :some_array_configuration
      self.some_array_configuration = [ :some_value ]
      some_array_configuration.should == [ :some_value ]
    end

    # including module 1
    module CascadingConfiguration::MockModule2
      include CascadingConfiguration::MockModule
      some_array_configuration.should == [ :some_value ]
      self.some_array_configuration = [ :module_value ]
      some_array_configuration.should == [ :module_value ]
    end

    # including module 2
    module CascadingConfiguration::MockModule3
      include CascadingConfiguration::MockModule2
      some_array_configuration.should == [ :module_value ]
    end

    # top class
    class CascadingConfiguration::MockClass
      include CascadingConfiguration::MockModule3
      some_array_configuration.should == [ :module_value ]
      self.some_array_configuration = [ :another_value ]
      some_array_configuration.should == [ :another_value ]
    end

    # instance of top class
    object_instance_one = CascadingConfiguration::MockClass.new
    object_instance_one.some_array_configuration.should == [ :another_value ]
    object_instance_one.some_array_configuration = [ :yet_another_value ]
    object_instance_one.some_array_configuration.should == [ :yet_another_value ]
    CascadingConfiguration::MockClass.some_array_configuration.should == [ :another_value ]
    CascadingConfiguration::MockModule.some_array_configuration.should == [ :some_value ]

    # first inheriting class
    class CascadingConfiguration::MockClassSub1 < CascadingConfiguration::MockClass
      some_array_configuration.should == [ :another_value ]
      self.some_array_configuration = [ :a_value_not_yet_used ]
      some_array_configuration.should == [ :a_value_not_yet_used ]
      CascadingConfiguration::MockClass.some_array_configuration.should == [ :another_value ]
      CascadingConfiguration::MockModule.some_array_configuration.should == [ :some_value ]
    end

    # Instance of First Inheriting Class
    object_instance_two = CascadingConfiguration::MockClassSub1.new
    object_instance_two.some_array_configuration.should == [ :a_value_not_yet_used ]
    object_instance_one.some_array_configuration.should == [ :yet_another_value ]
    CascadingConfiguration::MockClass.some_array_configuration.should == [ :another_value ]
    CascadingConfiguration::MockModule.some_array_configuration.should == [ :some_value ]

    # Second Inheriting Class
    class CascadingConfiguration::MockClassSub2 < CascadingConfiguration::MockClassSub1
      some_array_configuration.should == [ :a_value_not_yet_used ]
      self.some_array_configuration = [ :another_value_not_yet_used ]
      some_array_configuration.should == [ :another_value_not_yet_used ]
    end

    # Instance of Second Inheriting Class
    object_instance_three = CascadingConfiguration::MockClassSub2.new
    object_instance_three.some_array_configuration.should == [ :another_value_not_yet_used ]
    object_instance_three.some_array_configuration = [ :one_more_unused_value ]
    object_instance_three.some_array_configuration.should == [ :one_more_unused_value ]
    
  end
  
  #####################################
  #  attr_configuration_unique_array  #
  #####################################
  
  it 'can define a configuration array, which is the primary interface' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get attr_configuration and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_configuration and configurations
    # => instances of extending classes get nothing
    module CascadingConfiguration::ConfigurationMockModuleExtended
      extend CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_unique_array ).should == true
      attr_configuration_unique_array :some_unique_configuration_array
      respond_to?( :some_unique_configuration_array ).should == true
      some_unique_configuration_array.should == []
      some_unique_configuration_array.push( :a_configuration )
      some_unique_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_unique_configuration_array ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_unique_configuration_array ).should == false
        respond_to?( :some_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_unique_configuration_array ).should == false
        respond_to?( :some_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_unique_configuration_array ).should == false
        respond_to?( :some_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_unique_configuration_array ).should == false
        respond_to?( :some_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module CascadingConfiguration::ConfigurationMockModuleIncluded
      include CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_unique_array ).should == true
      attr_configuration_unique_array :some_unique_configuration_array
      respond_to?( :some_unique_configuration_array ).should == true
      some_unique_configuration_array.should == []
      some_unique_configuration_array.push( :a_configuration )
      some_unique_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_unique_configuration_array ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_configuration and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_unique_configuration_array ).should == true
        respond_to?( :some_unique_configuration_array ).should == true
        some_unique_configuration_array.should == [ :a_configuration ]
        some_unique_configuration_array.push( :another_configuration )
        some_unique_configuration_array.push( :another_configuration )
        some_unique_configuration_array.should == [ :a_configuration, :another_configuration ]
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_configuration and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_unique_configuration_array ).should == true
        some_unique_configuration_array.should == [ :a_configuration ]
        some_unique_configuration_array.push( :some_other_configuration )
        some_unique_configuration_array.push( :some_other_configuration )
        some_unique_configuration_array.push( :some_other_configuration )
        some_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_methods.include?( :some_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_unique_configuration_array ).should == true
        respond_to?( :some_unique_configuration_array ).should == true
        some_unique_configuration_array.should == [ :a_configuration ]
        some_unique_configuration_array.push( :some_other_configuration )
        some_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_unique_configuration_array ).should == true
      setting_class_including_instance.some_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
      setting_class_including_instance.some_unique_configuration_array.delete( :some_other_configuration )
      setting_class_including_instance.some_unique_configuration_array = [ :our_setting_value ]
      setting_class_including_instance.some_unique_configuration_array.should == [ :our_setting_value ]
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        respond_to?( :some_unique_configuration_array ).should == true
        some_unique_configuration_array.should == [ :a_configuration ]
        some_unique_configuration_array.push( :some_other_configuration )
        some_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_unique_configuration_array ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::ConfigurationMockClass
      include CascadingConfiguration::ConfigurationMockModuleIncluded::SubmoduleIncluding
      some_unique_configuration_array.should == [ :a_configuration, :another_configuration ]
      some_unique_configuration_array.push( :some_other_configuration )
      some_unique_configuration_array.push( :some_other_configuration )
      some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::ConfigurationMockClass.new
    object_instance_one.some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.some_unique_configuration_array.delete( :a_configuration )
    object_instance_one.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub1 < CascadingConfiguration::ConfigurationMockClass
      some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      some_unique_configuration_array.delete( :a_configuration )
      some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::ConfigurationMockClassSub1.new
    object_instance_two.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_two.some_unique_configuration_array.delete( :another_configuration )
    object_instance_two.some_unique_configuration_array.should == [ :some_other_configuration ]
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub2 < CascadingConfiguration::ConfigurationMockClassSub1
      some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      #some_unique_configuration_array.push( :yet_another_configuration )
      #some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::ConfigurationMockClass.some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_unique_configuration_array.push( :a_yet_unused_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_one.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.some_unique_configuration_array.should == [ :some_other_configuration, :a_yet_unused_configuration ]
    
    # freeze ancestor setting
    object_instance_one.some_unique_configuration_array.freeze!
    object_instance_one.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_unique_configuration_array.freeze!
    CascadingConfiguration::ConfigurationMockClassSub1.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_unique_configuration_array.push( :non_cascading_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration, :a_yet_unused_configuration, :non_cascading_configuration ]
    object_instance_one.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :a_yet_unused_configuration ]
    object_instance_two.some_unique_configuration_array.should == [ :some_other_configuration, :a_yet_unused_configuration ]
        
  end
  
  #####################################
  #  attr_configuration_sorted_array  #
  #####################################
  
  it 'can define a configuration array, which is the primary interface' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get attr_configuration and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_configuration and configurations
    # => instances of extending classes get nothing
    module CascadingConfiguration::ConfigurationMockModuleExtended
      extend CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_sorted_array ).should == true
      attr_configuration_sorted_array :some_sorted_configuration_array
      respond_to?( :some_sorted_configuration_array ).should == true
      some_sorted_configuration_array.should == []
      some_sorted_configuration_array.push( :a_configuration )
      some_sorted_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_sorted_configuration_array ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_configuration_array ).should == false
        respond_to?( :some_sorted_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_configuration_array ).should == false
        respond_to?( :some_sorted_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_configuration_array ).should == false
        respond_to?( :some_sorted_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_configuration_array ).should == false
        respond_to?( :some_sorted_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module CascadingConfiguration::ConfigurationMockModuleIncluded
      include CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_sorted_array ).should == true
      attr_configuration_sorted_array :some_sorted_configuration_array
      respond_to?( :some_sorted_configuration_array ).should == true
      some_sorted_configuration_array.should == []
      some_sorted_configuration_array.push( :a_configuration )
      some_sorted_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_sorted_configuration_array ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_configuration and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_sorted_configuration_array ).should == true
        respond_to?( :some_sorted_configuration_array ).should == true
        some_sorted_configuration_array.should == [ :a_configuration ]
        some_sorted_configuration_array.push( :another_configuration )
        some_sorted_configuration_array.should == [ :a_configuration, :another_configuration ]
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_configuration and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_sorted_configuration_array ).should == true
        some_sorted_configuration_array.should == [ :a_configuration ]
        some_sorted_configuration_array.push( :some_other_configuration )
        some_sorted_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_methods.include?( :some_sorted_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_sorted_configuration_array ).should == true
        respond_to?( :some_sorted_configuration_array ).should == true
        some_sorted_configuration_array.should == [ :a_configuration ]
        some_sorted_configuration_array.push( :some_other_configuration )
        some_sorted_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_sorted_configuration_array ).should == true
      setting_class_including_instance.some_sorted_configuration_array.should == [ :a_configuration, :some_other_configuration ]
      setting_class_including_instance.some_sorted_configuration_array.delete( :some_other_configuration )
      setting_class_including_instance.some_sorted_configuration_array = [ :our_setting_value ]
      setting_class_including_instance.some_sorted_configuration_array.should == [ :our_setting_value ]
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        respond_to?( :some_sorted_configuration_array ).should == true
        some_sorted_configuration_array.should == [ :a_configuration ]
        some_sorted_configuration_array.push( :some_other_configuration )
        some_sorted_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_sorted_configuration_array ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::ConfigurationMockClass
      include CascadingConfiguration::ConfigurationMockModuleIncluded::SubmoduleIncluding
      some_sorted_configuration_array.should == [ :a_configuration, :another_configuration ]
      some_sorted_configuration_array.push( :some_other_configuration )
      some_sorted_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::ConfigurationMockClass.new
    object_instance_one.some_sorted_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_configuration_array.delete( :a_configuration )
    object_instance_one.some_sorted_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub1 < CascadingConfiguration::ConfigurationMockClass
      some_sorted_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      some_sorted_configuration_array.delete( :a_configuration )
      some_sorted_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::ConfigurationMockClassSub1.new
    object_instance_two.some_sorted_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_configuration_array.delete( :another_configuration )
    object_instance_two.some_sorted_configuration_array.should == [ :some_other_configuration ]
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub2 < CascadingConfiguration::ConfigurationMockClassSub1
      some_sorted_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      some_sorted_configuration_array.push( :yet_another_configuration )
      some_sorted_configuration_array.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::ConfigurationMockClass.some_sorted_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_sorted_configuration_array.push( :a_yet_unused_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_sorted_configuration_array.should == [ :a_configuration, :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :some_other_configuration ]
    
    # freeze ancestor setting
    object_instance_one.some_sorted_configuration_array.freeze!
    object_instance_one.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_configuration_array.freeze!
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_sorted_configuration_array.push( :non_cascading_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_sorted_configuration_array.should == [ :a_configuration, :a_yet_unused_configuration, :another_configuration, :non_cascading_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_configuration_array.should == [ :a_yet_unused_configuration, :some_other_configuration ]
        
  end
  
  ############################################
  #  attr_configuration_sorted_unique_array  #
  ############################################
  
  it 'can define a configuration array, which is the primary interface' do

    # possibilities:
    # * module extended with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get nothing
    # => extending modules and classes get nothing
    # => instances of including and extending classes get nothing
    # * module included with setting
    # => singleton gets attr_configuration and configurations
    # => including modules and classes get attr_configuration and configurations
    # => instances of including classes get configurations
    # => extending modules and classes get attr_configuration and configurations
    # => instances of extending classes get nothing
    module CascadingConfiguration::ConfigurationMockModuleExtended
      extend CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_sorted_unique_array ).should == true
      attr_configuration_sorted_unique_array :some_sorted_unique_configuration_array
      respond_to?( :some_sorted_unique_configuration_array ).should == true
      some_sorted_unique_configuration_array.should == []
      some_sorted_unique_configuration_array.push( :a_configuration )
      some_sorted_unique_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
        respond_to?( :some_sorted_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
        respond_to?( :some_sorted_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
        respond_to?( :some_sorted_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleExtended
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
        respond_to?( :some_sorted_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module CascadingConfiguration::ConfigurationMockModuleIncluded
      include CascadingConfiguration
      # => singleton gets attr_configuration and configurations
      respond_to?( :attr_configuration_sorted_unique_array ).should == true
      attr_configuration_sorted_unique_array :some_sorted_unique_configuration_array
      respond_to?( :some_sorted_unique_configuration_array ).should == true
      some_sorted_unique_configuration_array.should == []
      some_sorted_unique_configuration_array.push( :a_configuration )
      some_sorted_unique_configuration_array.should == [ :a_configuration ]
      instance_methods.include?( :some_sorted_unique_configuration_array ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_configuration and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == true
        respond_to?( :some_sorted_unique_configuration_array ).should == true
        some_sorted_unique_configuration_array.should == [ :a_configuration ]
        some_sorted_unique_configuration_array.push( :another_configuration )
        some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration ]
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_configuration and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :some_sorted_unique_configuration_array ).should == true
        some_sorted_unique_configuration_array.should == [ :a_configuration ]
        some_sorted_unique_configuration_array.push( :some_other_configuration )
        some_sorted_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::ConfigurationMockModuleIncluded
        instance_methods.include?( :some_sorted_unique_configuration_array ).should == true
        respond_to?( :some_sorted_unique_configuration_array ).should == true
        some_sorted_unique_configuration_array.should == [ :a_configuration ]
        some_sorted_unique_configuration_array.push( :some_other_configuration )
        some_sorted_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :some_sorted_unique_configuration_array ).should == true
      setting_class_including_instance.some_sorted_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
      setting_class_including_instance.some_sorted_unique_configuration_array.delete( :some_other_configuration )
      setting_class_including_instance.some_sorted_unique_configuration_array = [ :our_setting_value ]
      setting_class_including_instance.some_sorted_unique_configuration_array.should == [ :our_setting_value ]
      setting_class_including_instance.instance_variables.empty?.should == true
      # => instances of extending classes get nothing
      class ClassExtending
        extend CascadingConfiguration::ConfigurationMockModuleIncluded
        respond_to?( :some_sorted_unique_configuration_array ).should == true
        some_sorted_unique_configuration_array.should == [ :a_configuration ]
        some_sorted_unique_configuration_array.push( :some_other_configuration )
        some_sorted_unique_configuration_array.should == [ :a_configuration, :some_other_configuration ]
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :some_sorted_unique_configuration_array ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::ConfigurationMockClass
      include CascadingConfiguration::ConfigurationMockModuleIncluded::SubmoduleIncluding
      some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration ]
      some_sorted_unique_configuration_array.push( :some_other_configuration )
      some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_one = CascadingConfiguration::ConfigurationMockClass.new
    object_instance_one.some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_unique_configuration_array.delete( :a_configuration )
    object_instance_one.some_sorted_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_one.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub1 < CascadingConfiguration::ConfigurationMockClass
      some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
      some_sorted_unique_configuration_array.delete( :a_configuration )
      some_sorted_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      instance_variables.empty?.should == true
    end
    object_instance_two = CascadingConfiguration::ConfigurationMockClassSub1.new
    object_instance_two.some_sorted_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_unique_configuration_array.delete( :another_configuration )
    object_instance_two.some_sorted_unique_configuration_array.should == [ :some_other_configuration ]
    object_instance_two.instance_variables.empty?.should == true
    class CascadingConfiguration::ConfigurationMockClassSub2 < CascadingConfiguration::ConfigurationMockClassSub1
      some_sorted_unique_configuration_array.should == [ :another_configuration, :some_other_configuration ]
      some_sorted_unique_configuration_array.push( :yet_another_configuration )
      some_sorted_unique_configuration_array.should == [ :another_configuration, :some_other_configuration, :yet_another_configuration ]
      instance_variables.empty?.should == true
    end

    # change ancestor setting
    CascadingConfiguration::ConfigurationMockClass.some_sorted_unique_configuration_array.should == [ :a_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_sorted_unique_configuration_array.push( :a_yet_unused_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_sorted_unique_configuration_array.should == [ :a_configuration, :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :some_other_configuration ]
    
    # freeze ancestor setting
    object_instance_one.some_sorted_unique_configuration_array.freeze!
    object_instance_one.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_unique_configuration_array.freeze!
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClass.some_sorted_unique_configuration_array.push( :non_cascading_configuration )
    CascadingConfiguration::ConfigurationMockClass.some_sorted_unique_configuration_array.should == [ :a_configuration, :a_yet_unused_configuration, :another_configuration, :non_cascading_configuration, :some_other_configuration ]
    object_instance_one.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    CascadingConfiguration::ConfigurationMockClassSub1.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :another_configuration, :some_other_configuration ]
    object_instance_two.some_sorted_unique_configuration_array.should == [ :a_yet_unused_configuration, :some_other_configuration ]
        
  end
  
  #############################
  #  attr_configuration_hash  #
  #############################
  
  it 'can declare an attribute as a cascading configuration hash' do

    # first module
    module CascadingConfiguration::MockModule
      attr_configuration_hash :some_hash_configuration
      self.some_hash_configuration = { :some_value => :some_value }
      some_hash_configuration.should == { :some_value => :some_value }
    end

    # including module 1
    module CascadingConfiguration::MockModule2
      some_hash_configuration.should == { :some_value => :some_value }
      self.some_hash_configuration = { :module_value => :some_value }
      some_hash_configuration.should == { :module_value => :some_value }
    end

    # including module 2
    module CascadingConfiguration::MockModule3

    end

    # top class
    class CascadingConfiguration::MockClass
      some_hash_configuration.should == {  }
      self.some_hash_configuration = { :another_value => :some_value }
      some_hash_configuration.should == { :another_value => :some_value }
    end

    # instance of top class
    object_instance_one = CascadingConfiguration::MockClass.new
    object_instance_one.some_hash_configuration.should == { :another_value => :some_value }
    object_instance_one.some_hash_configuration = { :yet_another_value => :some_value }
    object_instance_one.some_hash_configuration.should == { :yet_another_value => :some_value }
    CascadingConfiguration::MockClass.some_hash_configuration.should == { :another_value => :some_value }
    CascadingConfiguration::MockModule.some_hash_configuration.should == { :some_value => :some_value }

    # first inheriting class
    class CascadingConfiguration::MockClassSub1 < CascadingConfiguration::MockClass
      some_hash_configuration.should == { :another_value => :some_value }
      self.some_hash_configuration = { :a_value_not_yet_used => :some_value }
      some_hash_configuration.should == { :a_value_not_yet_used => :some_value }
      CascadingConfiguration::MockClass.some_hash_configuration.should == { :another_value => :some_value }
      CascadingConfiguration::MockModule.some_hash_configuration.should == { :some_value => :some_value }
    end

    # Instance of First Inheriting Class
    object_instance_two = CascadingConfiguration::MockClassSub1.new
    object_instance_two.some_hash_configuration.should == { :a_value_not_yet_used => :some_value }
    object_instance_one.some_hash_configuration.should == { :yet_another_value => :some_value }
    CascadingConfiguration::MockClass.some_hash_configuration.should == { :another_value => :some_value }
    CascadingConfiguration::MockModule.some_hash_configuration.should == { :some_value => :some_value }

    # Second Inheriting Class
    class CascadingConfiguration::MockClassSub2 < CascadingConfiguration::MockClassSub1
      some_hash_configuration.should == { :a_value_not_yet_used => :some_value }
      self.some_hash_configuration = { :another_value_not_yet_used => :some_value }
      some_hash_configuration.should == { :another_value_not_yet_used => :some_value }
    end

    # Instance of Second Inheriting Class
    object_instance_three = CascadingConfiguration::MockClassSub2.new
    object_instance_three.some_hash_configuration.should == { :another_value_not_yet_used => :some_value }
    object_instance_three.some_hash_configuration = { :one_more_unused_value => :some_value }
    object_instance_three.some_hash_configuration.should == { :one_more_unused_value => :some_value }
    
  end
  
end
