
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
