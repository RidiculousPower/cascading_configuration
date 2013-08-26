# -*- encoding : utf-8 -*-

require_relative '../lib/cascading_configuration.rb'

require_relative 'support/named_class_and_module.rb'

describe ::CascadingConfiguration do
  
  let( :mock_class_one ) do
    ::Class.new do
      extend ::CascadingConfiguration
      attr_configuration :configuration_one, :configuration_two
      attr_object_array :array_one, :array_two, :array_three
    end.name( :MockClassOne )
  end

  let( :mock_class_two ) do
    ::Class.new do
      extend ::CascadingConfiguration
      attr_configuration :configuration_one, :configuration_two
      attr_object_array :array_one, :array_two, :array_three
    end
  end.name( :MockClassTwo )

  let( :instance_one  ) { mock_class_one.new.name( :InstanceOne ) }
  let( :instance_two  ) { mock_class_one.new.name( :InstanceTwo ) }
  let( :instance_three  ) { mock_class_one.new.name( :InstanceThree ) }
  
  ###################
  #  self.extended  #
  ###################
  
  context '::extended' do
    let( :extending_class  ) { ::Class.new.extend( ::CascadingConfiguration ) }
    it 'enables extending class singleton (only) with all cascading_configuration modules' do
      ::CascadingConfiguration::Setting.should === extending_class
      ::CascadingConfiguration::Hash.should === extending_class
      ::CascadingConfiguration::Array.should === extending_class
      ::CascadingConfiguration::Array::Unique.should === extending_class
      ::CascadingConfiguration::Array::Sorted.should === extending_class
      ::CascadingConfiguration::Array::Sorted::Unique.should === extending_class
    end
  end

  ###########################################################
  #  Cascading Configurations to Already Existant Children  #
  ###########################################################
  
  context 'Cascading Configurations to Already Existant Children' do
    let( :module_A ) { ::Module.new.name( :ModuleA ) }
    let( :module_B ) { _module_A = module_A ; ::Module.new { include _module_A }.name( :ModuleB ) }
    let( :class_A ) { _module_B = module_B ; ::Class.new { include _module_B }.name( :ClassA ) }
    let( :class_B ) { ::Class.new( class_A ).name( :ClassB ) }
    let( :class_C ) { ::Class.new( class_B ).name( :ClassC ) }
    let( :class_D ) { ::Class.new( class_C ).name( :ClassD ) }
    before :each do
      class_D
      # A doesn't know about B, C, D so they don't properly inherit configurations
      module_A.module_eval do
        extend ::CascadingConfiguration::Setting
        attr_setting :configuration_A, :configuration_B
      end
    end
    it 'will register parents properly after the fact (I believe this only applies to subclasses created before the class is extended by a CascadingConfiguration module)' do
      module_B.•configuration_A.parent.should be module_A.•configuration_A
      module_B.•configuration_B.parent.should be module_A.•configuration_B

      class_A.•configuration_A.parent.should be module_B.•configuration_A
      class_A.•configuration_B.parent.should be module_B.•configuration_B

      class_B.•configuration_A.parent.should be class_A.•configuration_A
      class_B.•configuration_B.parent.should be class_A.•configuration_B

      class_C.•configuration_A.parent.should be class_B.•configuration_A
      class_C.•configuration_B.parent.should be class_B.•configuration_B

      class_D.•configuration_A.parent.should be class_C.•configuration_A
      class_D.•configuration_B.parent.should be class_C.•configuration_B
    end
  end
  
  ##############################################################################
  #  Cascading Compositing Object Configurations to Already Existant Children  #
  ##############################################################################
  
  context 'Cascading Compositing Object Configurations to Already Existant Children' do
    let( :module_A ) { ::Module.new.name( :ModuleA ) }
    let( :module_B ) { _module_A = module_A ; ::Module.new { include _module_A }.name( :ModuleB ) }
    let( :class_A ) { _module_B = module_B ; ::Class.new { include _module_B }.name( :ClassA ) }
    let( :class_B ) { ::Class.new( class_A ).name( :ClassB ) }
    let( :class_C ) { ::Class.new( class_B ).name( :ClassC ) }
    let( :class_D ) { ::Class.new( class_C ).name( :ClassD ) }
    before :each do
      class_D
      # A doesn't know about B, C, D so they don't properly inherit configurations
      module_A.module_eval do
        extend ::CascadingConfiguration::Array
        attr_array :configuration_A, :configuration_B
      end
    end
    it 'will register parents properly after the fact (I believe this only applies to subclasses created before the class is extended by a CascadingConfiguration module)' do

      module_B.•configuration_A.parents.include?( module_A.•configuration_A ).should be true
      module_B.•configuration_B.parents.include?( module_A.•configuration_B ).should be true

      class_A.•configuration_A.parents.include?( module_B.•configuration_A ).should be true
      class_A.•configuration_B.parents.include?( module_B.•configuration_B ).should be true

      class_B.•configuration_A.parents.include?( class_A.•configuration_A ).should be true
      class_B.•configuration_B.parents.include?( class_A.•configuration_B ).should be true

      class_C.•configuration_A.parents.include?( class_B.•configuration_A ).should be true
      class_C.•configuration_B.parents.include?( class_B.•configuration_B ).should be true
      
    end
  end
  
  #############################################
  #  self.share_all_singleton_configurations  #
  #############################################

  context '::share_all_singleton_configurations' do
    before :each do
      ::CascadingConfiguration.share_all_singleton_configurations( instance_one, instance_two )
    end
    it 'will share singleton configurations for an instance so that they are the same configuration instances as another instance' do
      ::CascadingConfiguration.singleton_configurations( instance_two ).should be ::CascadingConfiguration.singleton_configurations( instance_one )
    end
  end

  ############################################
  #  self.share_all_instance_configurations  #
  ############################################

  context '::share_all_instance_configurations' do
    before :each do
      ::CascadingConfiguration.share_all_instance_configurations( instance_one, instance_two )
    end
    it 'will share instance configurations for an instance so that they are the same configuration instances as another instance' do
      ::CascadingConfiguration.instance_configurations( instance_two ).should be ::CascadingConfiguration.instance_configurations( instance_one )
    end
  end

  ##########################################
  #  self.share_all_object_configurations  #
  ##########################################

  context '::share_all_object_configurations' do
    before :each do
      ::CascadingConfiguration.share_all_object_configurations( instance_one, instance_two )
    end
    it 'will share object configurations for an instance so that they are the same configuration instances as another instance' do
      ::CascadingConfiguration.object_configurations( instance_two ).should be ::CascadingConfiguration.object_configurations( instance_one )
    end
  end
  
  ###################################
  #  self.share_all_configurations  #
  ###################################
  
  context '::share_all_configurations' do
    before :each do
      ::CascadingConfiguration.share_all_configurations( instance_one, instance_two )
    end
    it 'will share all configurations for an instance so that they are the same configuration instances as another instance' do
      ::CascadingConfiguration.singleton_configurations( instance_two ).should be ::CascadingConfiguration.singleton_configurations( instance_one )
      ::CascadingConfiguration.instance_configurations( instance_two ).should be ::CascadingConfiguration.instance_configurations( instance_one )
      ::CascadingConfiguration.object_configurations( instance_two ).should be ::CascadingConfiguration.object_configurations( instance_one )
    end
  end
  
  ###################################################
  #  self.objects_sharing_singleton_configurations  #
  ###################################################
  
  context '::objects_sharing_singleton_configurations' do
    it 'will create or return a unique array for object ID' do
      sharing_objects = ::CascadingConfiguration.objects_sharing_singleton_configurations( instance_one, true )
      sharing_objects.should be_a ::Array::Unique
      ::CascadingConfiguration.objects_sharing_singleton_configurations( instance_one, true ).should be sharing_objects
    end
  end

  ##################################################
  #  self.objects_sharing_instance_configurations  #
  ##################################################
  
  context '::objects_sharing_instance_configurations' do
    it 'will create or return a unique array for object ID' do
      sharing_objects = ::CascadingConfiguration.objects_sharing_instance_configurations( instance_one, true )
      sharing_objects.should be_a ::Array::Unique
      ::CascadingConfiguration.objects_sharing_instance_configurations( instance_one, true ).should be sharing_objects
    end
  end

  ################################################
  #  self.objects_sharing_object_configurations  #
  ################################################

  context '::objects_sharing_object_configurations' do
    it 'will create or return a unique array for object ID' do
      sharing_objects = ::CascadingConfiguration.objects_sharing_object_configurations( instance_one, true )
      sharing_objects.should be_a ::Array::Unique
      ::CascadingConfiguration.objects_sharing_object_configurations( instance_one, true ).should be sharing_objects
    end
  end

  #########################################
  #  self.share_singleton_configurations  #
  #########################################

  context '::share_singleton_configurations' do
    before :each do
      ::CascadingConfiguration.share_singleton_configurations( mock_class_one, mock_class_two )
    end
    it 'will share singleton configurations for an instance so that they are the same configuration instances as another instance when configuration has been defined for both instances' do
      mock_class_one.•configuration_one.should be mock_class_two.•configuration_one
      mock_class_one.•configuration_two.should be mock_class_two.•configuration_two
      instance_one.•configuration_one.should_not be instance_two.•configuration_one
      instance_one.•configuration_two.should_not be instance_two.•configuration_two
    end
  end

  ########################################
  #  self.share_instance_configurations  #
  ########################################

  context '::share_instance_configurations' do
    before :each do
      ::CascadingConfiguration.share_instance_configurations( instance_one, instance_two )
    end
    it 'will share instance configurations for an instance so that they are the same configuration instances as another instance when configuration has been defined for both instances' do
      mock_class_one.•configuration_one.should_not be mock_class_two.•configuration_one
      mock_class_one.•configuration_two.should_not be mock_class_two.•configuration_two
      instance_one.•configuration_one.should be instance_two.•configuration_one
      instance_one.•configuration_two.should be instance_two.•configuration_two
    end
  end

  ######################################
  #  self.share_object_configurations  #
  ######################################

  context '::share_object_configurations' do
    before :each do
      ::CascadingConfiguration.share_object_configurations( mock_class_one, mock_class_two )
    end
    it 'will share object configurations for an instance so that they are the same configuration instances as another instance when configuration has been defined for both instances' do
      ::CascadingConfiguration.object_configuration( mock_class_one, :array_one ).should be ::CascadingConfiguration.object_configuration( mock_class_two, :array_one )
      ::CascadingConfiguration.object_configuration( mock_class_one, :array_two ).should be ::CascadingConfiguration.object_configuration( mock_class_two, :array_two )
    end
  end
  
  ###############################
  #  self.share_configurations  #
  ###############################
  
  context '::share_configurations' do
    before :each do
      ::CascadingConfiguration.share_configurations( mock_class_one, mock_class_two )
      ::CascadingConfiguration.share_configurations( instance_one, instance_two )
    end
    it 'will share configurations for an instance so that they are the same configuration instances as another instance when configuration has been defined for both instances' do
      mock_class_one.•configuration_one.should be mock_class_two.•configuration_one
      mock_class_one.•configuration_two.should be mock_class_two.•configuration_two
      instance_one.•configuration_one.should be instance_two.•configuration_one
      instance_one.•configuration_two.should be instance_two.•configuration_two
      ::CascadingConfiguration.object_configuration( mock_class_one, :array_one ).should be ::CascadingConfiguration.object_configuration( mock_class_two, :array_one )
      ::CascadingConfiguration.object_configuration( mock_class_one, :array_two ).should be ::CascadingConfiguration.object_configuration( mock_class_two, :array_two )
    end
  end

end
