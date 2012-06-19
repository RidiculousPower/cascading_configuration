
require_relative '../../lib/cascading-configuration.rb'

describe CascadingConfiguration::Hash do
  
  ###############
  #  attr_hash  #
  ###############
  
  it 'can define a configuration hash, which is the primary interface' do

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
    module ::CascadingConfiguration::Hash::ConfigurationMockModuleExtended
      extend CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_hash ).should == true
      respond_to?( :attr_configuration_hash ).should == true
      attr_hash :configuration_setting, :some_other_hash
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Hash::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Hash::ConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Hash::ConfigurationMockModuleIncluded
      include CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_hash ).should == true
      attr_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Hash::ConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.configuration_setting.should == { :a_configuration => :some_value }
      setting_class_including_instance.configuration_setting.delete( :a_configuration )
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassExtending
        extend CascadingConfiguration::Hash::ConfigurationMockModuleIncluded
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Hash::ConfigurationMockClass
      include CascadingConfiguration::Hash::ConfigurationMockModuleIncluded::SubmoduleIncluding
      configuration_setting.should == { :a_configuration => :some_value }
      configuration_setting[ :other_setting ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value,
                                        :other_setting   => :some_value }
      configuration_setting.delete( :other_setting ).should == :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      instance_variables.empty?.should == true
    end

    object_instance_one = CascadingConfiguration::Hash::ConfigurationMockClass.new
    object_instance_one.configuration_setting.should == { :a_configuration => :some_value }
    object_instance_one.configuration_setting[ :some_other_configuration ] = :some_value
    object_instance_one.configuration_setting.should == { :a_configuration          => :some_value,
                                                          :some_other_configuration => :some_value }
    object_instance_one.instance_variables.empty?.should == true
    
    class CascadingConfiguration::Hash::ConfigurationMockClassSub1 < CascadingConfiguration::Hash::ConfigurationMockClass
      configuration_setting.should == { :a_configuration => :some_value }
      self.configuration_setting[ :another_configuration ] = :some_value
      configuration_setting.should == { :a_configuration       => :some_value,
                                        :another_configuration => :some_value }
      instance_variables.empty?.should == true
    end

    object_instance_two = CascadingConfiguration::Hash::ConfigurationMockClassSub1.new
    object_instance_two.configuration_setting.should == { :a_configuration       => :some_value,
                                                          :another_configuration => :some_value }
    object_instance_two.configuration_setting[ :some_other_configuration ] = :some_value
    object_instance_two.configuration_setting.should == { :a_configuration          => :some_value,
                                                          :another_configuration    => :some_value,
                                                          :some_other_configuration => :some_value }
    object_instance_two.instance_variables.empty?.should == true

    # change ancestor setting
    CascadingConfiguration::Hash::ConfigurationMockClass.configuration_setting[ :a_yet_unused_configuration ] = :some_value
    CascadingConfiguration::Hash::ConfigurationMockClass.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                           :a_yet_unused_configuration => :some_value }
    object_instance_one.configuration_setting.should == { :a_configuration            => :some_value,
                                                          :a_yet_unused_configuration => :some_value,
                                                          :some_other_configuration   => :some_value }
    CascadingConfiguration::Hash::ConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                               :a_yet_unused_configuration => :some_value,
                                                                                               :another_configuration      => :some_value }
    object_instance_two.configuration_setting.should == { :a_configuration            => :some_value,
                                                          :a_yet_unused_configuration => :some_value,
                                                          :another_configuration      => :some_value,
                                                          :some_other_configuration   => :some_value }

    # freeze ancestor setting
    object_instance_one.configuration_setting.freeze!
    object_instance_one.configuration_setting.should == { :a_configuration            => :some_value,
                                                          :a_yet_unused_configuration => :some_value,
                                                          :some_other_configuration   => :some_value }
    CascadingConfiguration::Hash::ConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Hash::ConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                               :a_yet_unused_configuration => :some_value,
                                                                                               :another_configuration      => :some_value }
    CascadingConfiguration::Hash::ConfigurationMockClass.configuration_setting[ :non_cascading_configuration ] = :some_value
    CascadingConfiguration::Hash::ConfigurationMockClass.configuration_setting.should == { :a_configuration             => :some_value,
                                                                                           :a_yet_unused_configuration  => :some_value,
                                                                                           :non_cascading_configuration => :some_value }
    object_instance_one.configuration_setting.should == { :a_configuration            => :some_value,
                                                          :a_yet_unused_configuration => :some_value,
                                                          :some_other_configuration   => :some_value }
    CascadingConfiguration::Hash::ConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                               :a_yet_unused_configuration => :some_value,
                                                                                               :another_configuration      => :some_value }
    object_instance_two.configuration_setting.should == { :a_configuration            => :some_value,
                                                          :a_yet_unused_configuration => :some_value,
                                                          :another_configuration      => :some_value,
                                                          :some_other_configuration   => :some_value }

    module ::CascadingConfiguration::Hash::ConfigurationMockModule
      include CascadingConfiguration::Hash
      attr_hash :some_hash do
        def merge!( other_hash )
          other_hash.each do |key, foreign_value|
            if existing_value = self[ key ]
              self[ key ] = foreign_value - existing_value
            else
              self[ key ] = foreign_value
            end          
          end
        end
      end
      self.some_hash = { :one => 1, :two => 2 }
      self.some_hash.should == { :one => 1, :two => 2 }
    end

    module ::CascadingConfiguration::Hash::ConfigurationMockModule2
      include CascadingConfiguration::Hash::ConfigurationMockModule
      self.some_hash.should == { :one => 1, :two => 2 }
      self.some_hash.merge!( { :one => 1, :two => 2 } )
      self.some_hash.should == { :one => 0, :two => 0 }
    end
    
  end
  
  ######################
  #  attr_module_hash  #
  #  attr_class_hash   #
  ######################
  
  it 'can define a class configuration hash, which will not cascade to instances' do

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
    module ::CascadingConfiguration::Hash::ClassConfigurationMockModuleExtended
      extend CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_configuration_hash ).should == true
      respond_to?( :attr_module_hash ).should == true
      method( :attr_module_hash ).should == method( :attr_class_hash )
      attr_module_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Hash::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Hash::ClassConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded
      include CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_module_hash ).should == true
      attr_module_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        method_defined?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassExtending
        extend CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded
        respond_to?( :configuration_setting ).should == true
        method_defined?( :configuration_setting ).should == false
        configuration_setting.should == { :a_configuration => :some_value }
        configuration_setting[ :other_setting ] = :some_value
        configuration_setting.should == { :a_configuration => :some_value,
                                          :other_setting   => :some_value }
        configuration_setting.delete( :other_setting ).should == :some_value
        configuration_setting.should == { :a_configuration => :some_value }
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Hash::ClassConfigurationMockClass
      include CascadingConfiguration::Hash::ClassConfigurationMockModuleIncluded::SubmoduleIncluding
      respond_to?( :configuration_setting ).should == true
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == { :a_configuration => :some_value }
      configuration_setting[ :other_setting ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value,
                                        :other_setting   => :some_value }
      configuration_setting.delete( :other_setting ).should == :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      instance_variables.empty?.should == true
    end

    object_instance_one = CascadingConfiguration::Hash::ClassConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    
    class CascadingConfiguration::Hash::ClassConfigurationMockClassSub1 < CascadingConfiguration::Hash::ClassConfigurationMockClass
      respond_to?( :configuration_setting ).should == true
      method_defined?( :configuration_setting ).should == false
      configuration_setting.should == { :a_configuration => :some_value }
      self.configuration_setting[ :another_configuration ] = :some_value
      configuration_setting.should == { :a_configuration       => :some_value,
                                        :another_configuration => :some_value }
      instance_variables.empty?.should == true
    end

    object_instance_two = CascadingConfiguration::Hash::ClassConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false

    # change ancestor setting
    CascadingConfiguration::Hash::ClassConfigurationMockClass.configuration_setting[ :a_yet_unused_configuration ] = :some_value
    CascadingConfiguration::Hash::ClassConfigurationMockClass.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                                :a_yet_unused_configuration => :some_value }
    CascadingConfiguration::Hash::ClassConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                                    :a_yet_unused_configuration => :some_value,
                                                                                                    :another_configuration      => :some_value }

    # freeze ancestor setting
    CascadingConfiguration::Hash::ClassConfigurationMockClassSub1.configuration_setting.freeze!
    CascadingConfiguration::Hash::ClassConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                                    :a_yet_unused_configuration => :some_value,
                                                                                                    :another_configuration      => :some_value }
    CascadingConfiguration::Hash::ClassConfigurationMockClass.configuration_setting[ :non_cascading_configuration ] = :some_value
    CascadingConfiguration::Hash::ClassConfigurationMockClass.configuration_setting.should == { :a_configuration             => :some_value,
                                                                                                :a_yet_unused_configuration  => :some_value,
                                                                                                :non_cascading_configuration => :some_value }
    CascadingConfiguration::Hash::ClassConfigurationMockClassSub1.configuration_setting.should == { :a_configuration            => :some_value,
                                                                                                    :a_yet_unused_configuration => :some_value,
                                                                                                    :another_configuration      => :some_value }

    module ::CascadingConfiguration::Hash::ClassConfigurationMockModule
      include CascadingConfiguration::Hash
      attr_hash :some_hash do
        def merge!( other_hash )
          other_hash.each do |key, foreign_value|
            if existing_value = self[ key ]
              self[ key ] = foreign_value - existing_value
            else
              self[ key ] = foreign_value
            end          
          end
        end
      end
      self.some_hash = { :one => 1, :two => 2 }
      self.some_hash.should == { :one => 1, :two => 2 }
    end

    module ::CascadingConfiguration::Hash::ClassConfigurationMockModule2
      include CascadingConfiguration::Hash::ClassConfigurationMockModule
      self.some_hash.should == { :one => 1, :two => 2 }
      self.some_hash.merge!( { :one => 1, :two => 2 } )
      self.some_hash.should == { :one => 0, :two => 0 }
    end
    
  end
  
  #####################
  #  attr_local_hash  #
  #####################
  
  it 'can define a local configuration hash, which will not cascade' do

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
    module ::CascadingConfiguration::Hash::LocalConfigurationMockModuleExtended
      extend CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_configuration_hash ).should == true
      respond_to?( :attr_local_hash ).should == true
      attr_local_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Hash::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Hash::LocalConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded
      include CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_local_hash ).should == true
      attr_local_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassExtending
        extend CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Hash::LocalConfigurationMockClass
      include CascadingConfiguration::Hash::LocalConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_one = CascadingConfiguration::Hash::LocalConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    
    class CascadingConfiguration::Hash::LocalConfigurationMockClassSub1 < CascadingConfiguration::Hash::LocalConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_two = CascadingConfiguration::Hash::LocalConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true

  end
  
  ########################
  #  attr_instance_hash  #
  ########################
  
  it 'can define a local configuration hash, which will not cascade' do

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
    module ::CascadingConfiguration::Hash::InstanceConfigurationMockModuleExtended
      extend CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Hash::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Hash::InstanceConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded
      include CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_instance_hash ).should == true
      attr_instance_hash :configuration_setting
      respond_to?( :configuration_setting ).should == false
      method_defined?( :configuration_setting ).should == true
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == true
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == true
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassExtending
        extend CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == true
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Hash::InstanceConfigurationMockClass
      include CascadingConfiguration::Hash::InstanceConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_one = CascadingConfiguration::Hash::InstanceConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == true
    object_instance_one.instance_variables.empty?.should == true
    
    class CascadingConfiguration::Hash::InstanceConfigurationMockClassSub1 < CascadingConfiguration::Hash::InstanceConfigurationMockClass
      method_defined?( :configuration_setting ).should == true
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_two = CascadingConfiguration::Hash::InstanceConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == true
    object_instance_two.instance_variables.empty?.should == true

  end
  
  ######################
  #  attr_object_hash  #
  ######################
  
  it 'can define a local configuration hash, which will not cascade' do

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
    module ::CascadingConfiguration::Hash::ObjectConfigurationMockModuleExtended
      extend CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_configuration_hash ).should == true
      respond_to?( :attr_object_hash ).should == true
      attr_object_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get nothing
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get nothing
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including and extending classes get nothing
      class ClassIncluding
        include CascadingConfiguration::Hash::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      class ClassExtending
        extend CascadingConfiguration::Hash::ObjectConfigurationMockModuleExtended
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
    end

    # * module included with setting
    module ::CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded
      include CascadingConfiguration::Hash
      # => singleton gets attr_setting and configurations
      respond_to?( :attr_object_hash ).should == true
      attr_object_hash :configuration_setting
      respond_to?( :configuration_setting ).should == true
      configuration_setting.should == {}
      self.configuration_setting[ :a_configuration ] = :some_value
      configuration_setting.should == { :a_configuration => :some_value }
      method_defined?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
      # => including modules and classes get attr_setting and configurations
      module SubmoduleIncluding
        include CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => extending modules and classes get attr_setting and configurations
      module SubmoduleExtending
        extend CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded
        # if we're extended then we want to use the eigenclass ancestor chain
        # - the first ancestor will be the extending module
        # - the rest of the ancestors will be the extending module's include chain
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      # => instances of including classes get configurations
      class ClassIncluding
        include CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassIncluding.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
      class ClassExtending
        extend CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded
        method_defined?( :configuration_setting ).should == false
        respond_to?( :configuration_setting ).should == false
        instance_variables.empty?.should == true
      end
      setting_class_including_instance = ClassExtending.new
      setting_class_including_instance.respond_to?( :configuration_setting ).should == false
      setting_class_including_instance.instance_variables.empty?.should == true
    end

    class CascadingConfiguration::Hash::ObjectConfigurationMockClass
      include CascadingConfiguration::Hash::ObjectConfigurationMockModuleIncluded::SubmoduleIncluding
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_one = CascadingConfiguration::Hash::ObjectConfigurationMockClass.new
    object_instance_one.respond_to?( :configuration_setting ).should == false
    object_instance_one.instance_variables.empty?.should == true
    
    class CascadingConfiguration::Hash::ObjectConfigurationMockClassSub1 < CascadingConfiguration::Hash::ObjectConfigurationMockClass
      method_defined?( :configuration_setting ).should == false
      respond_to?( :configuration_setting ).should == false
      instance_variables.empty?.should == true
    end

    object_instance_two = CascadingConfiguration::Hash::ObjectConfigurationMockClassSub1.new
    object_instance_two.respond_to?( :configuration_setting ).should == false
    object_instance_two.instance_variables.empty?.should == true

  end
  
end
