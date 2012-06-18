
require_relative '../lib/cascading-configuration.rb'

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
  
end
