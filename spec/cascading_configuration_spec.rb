# -*- encoding : utf-8 -*-

require_relative '../lib/cascading_configuration.rb'

require_relative 'support/named_class_and_module.rb'

describe ::CascadingConfiguration do
  
  it 'acts as a cluster' do

    module ::CascadingConfiguration::ClusterIncludeMock

      include ::CascadingConfiguration

      ancestors.include?( ::CascadingConfiguration::Setting ).should == true
      is_a?( ::CascadingConfiguration::Setting::ClassInstance ).should == true

      ancestors.include?( ::CascadingConfiguration::Hash ).should == true
      is_a?( ::CascadingConfiguration::Hash::ClassInstance ).should == true

      ancestors.include?( ::CascadingConfiguration::Array ).should == true
      is_a?( ::CascadingConfiguration::Array::ClassInstance ).should == true

      ancestors.include?( ::CascadingConfiguration::Array::Unique ).should == true
      is_a?( ::CascadingConfiguration::Array::Unique::ClassInstance ).should == true

      ancestors.include?( ::CascadingConfiguration::Array::Sorted ).should == true
      is_a?( ::CascadingConfiguration::Array::Sorted::ClassInstance ).should == true

      ancestors.include?( ::CascadingConfiguration::Array::Sorted::Unique ).should == true
      is_a?( ::CascadingConfiguration::Array::Sorted::Unique::ClassInstance ).should == true

    end

    module ::CascadingConfiguration::ClusterExtendMock

      extend ::CascadingConfiguration

      is_a?( ::CascadingConfiguration::Setting ).should == true
      is_a?( ::CascadingConfiguration::Setting::ClassInstance ).should == true

      is_a?( ::CascadingConfiguration::Hash ).should == true
      is_a?( ::CascadingConfiguration::Hash::ClassInstance ).should == true

      is_a?( ::CascadingConfiguration::Array ).should == true
      is_a?( ::CascadingConfiguration::Array::ClassInstance ).should == true

      is_a?( ::CascadingConfiguration::Array::Unique ).should == true
      is_a?( ::CascadingConfiguration::Array::Unique::ClassInstance ).should == true

      is_a?( ::CascadingConfiguration::Array::Sorted ).should == true
      is_a?( ::CascadingConfiguration::Array::Sorted::ClassInstance ).should == true

      is_a?( ::CascadingConfiguration::Array::Sorted::Unique ).should == true
      is_a?( ::CascadingConfiguration::Array::Sorted::Unique::ClassInstance ).should == true

    end

  end

  ############################################
  #  self.ensure_no_unregistered_superclass  #
  ############################################
  
  context '::ensure_no_unregistered_superclass' do
    let( :class_A ) { ::Class.new.name( :ClassA ) }
    let( :class_B ) { ::Class.new( class_A ).name( :ClassB ) }
    let( :class_C ) { ::Class.new( class_B ).name( :ClassC ) }
    let( :class_D ) { ::Class.new( class_C ).name( :ClassD ) }
    before :each do
      class_D
      # A doesn't know about B, C, D so they don't properly inherit configurations
      class_A.class_eval do
        include ::CascadingConfiguration::Setting
        attr_setting :configuration_A, :configuration_B
      end
    end
    it 'will register parents properly after the fact (I believe this only applies to subclasses created before the class includes a CascadingConfiguration module)' do
      ::CascadingConfiguration.ensure_no_unregistered_superclass( class_D )
      ::CascadingConfiguration.has_configuration?( class_B, :configuration_A ).should be true
      ::CascadingConfiguration.configuration( class_B, :configuration_A ).parent.should be ::CascadingConfiguration.configuration( class_A, :configuration_A )
      ::CascadingConfiguration.has_configuration?( class_B, :configuration_B ).should be true
      ::CascadingConfiguration.configuration( class_B, :configuration_B ).parent.should be ::CascadingConfiguration.configuration( class_A, :configuration_B )
      
      ::CascadingConfiguration.has_configuration?( class_C, :configuration_A ).should be true
      ::CascadingConfiguration.configuration( class_C, :configuration_A ).parent.should be ::CascadingConfiguration.configuration( class_B, :configuration_A )
      ::CascadingConfiguration.has_configuration?( class_C, :configuration_B ).should be true
      ::CascadingConfiguration.configuration( class_C, :configuration_B ).parent.should be ::CascadingConfiguration.configuration( class_B, :configuration_B )

      ::CascadingConfiguration.has_configuration?( class_D, :configuration_A ).should be true
      ::CascadingConfiguration.configuration( class_D, :configuration_A ).parent.should be ::CascadingConfiguration.configuration( class_C, :configuration_A )
      ::CascadingConfiguration.has_configuration?( class_D, :configuration_B ).should be true
      ::CascadingConfiguration.configuration( class_D, :configuration_B ).parent.should be ::CascadingConfiguration.configuration( class_C, :configuration_B )
    end
  end
  
end
