# -*- encoding : utf-8 -*-

require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../configuration_shared.rb'
require_relative 'configuration_setup.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues::Configuration do

  setup_cascading_values_configuration_tests
  
  let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues::Configuration }
  
  it_behaves_like ::CascadingConfiguration::Module::Configuration
  
  ###################
  #  cascade_block  #
  ###################
  
  context 'cascade_block' do
    it 'has a block that generates cascade value' do
      parent_configuration.cascade_block.should be parent_configuration_block
      child_configuration.cascade_block.should be child_configuration_block
    end
    context 'when no block provided' do
      let( :parent_configuration_block ) { nil }
      it 'raises ArgumentError' do
        ::Proc.new { parent_configuration }.should raise_error( ::ArgumentError )
      end
    end
  end
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  context '#permits_multiple_parents?' do
    it 'does not' do
      parent_configuration.permits_multiple_parents?.should be false
    end
  end
  
  ####################
  #  register_child  #
  ####################
  
  context '#register_child' do
    it 'tracks children to pass values downward' do
      parent_configuration.register_child( child_configuration )
      child_configuration.parent.should be parent_configuration_two
    end
  end

  ############
  #  parent  #
  ############
  
  context '#parent' do
    it 'tracks its parent' do
      parent_configuration.parent.should be nil
      parent_configuration_two.parent.should be parent_configuration
      child_configuration.parent.should be parent_configuration_two
    end
  end
  
  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    it 'can replace parent with another' do
      parent_configuration_two.replace_parent( child_configuration )
      parent_configuration_two.parent.should be child_configuration
    end
  end

  ######################
  #  unregister_child  #
  ######################

  context '#unregister_child' do
    it 'can unregister child' do
      parent_configuration_two.is_child?( child_configuration ).should be true
      parent_configuration_two.unregister_child( child_configuration )
      parent_configuration_two.is_child?( child_configuration ).should be false
      child_configuration.parent.should be nil
    end
  end
  
  #######################
  #  unregister_parent  #
  #######################

  context '#unregister_parent' do
    it 'can unregister child' do
      parent_configuration_two.is_child?( child_configuration ).should be true
      child_configuration.unregister_parent( parent_configuration_two )
      parent_configuration_two.is_child?( child_configuration ).should be false
      child_configuration.parent.should be nil
    end
  end
  
  ###################
  #  has_children?  #
  ###################

  context '#has_children?' do
    before( :each ) { child_configuration }
    it 'reports if it has children' do
      parent_configuration.has_children?.should be true
      parent_configuration_two.has_children?.should be true
      child_configuration.has_children?.should be false
    end
  end
  
  #################
  #  has_parent?  #
  #################

  context '#has_parent?' do
    it 'reports if it has a parent' do
      parent_configuration.has_parent?.should be false
      parent_configuration_two.has_parent?.should be true
      child_configuration.has_parent?.should be true
    end
  end

  ###############
  #  is_child?  #
  ###############

  context '#is_child?' do
    it 'reports if it is a child' do
      parent_configuration.is_child?( parent_configuration_two ).should be true
      parent_configuration.is_child?( child_configuration ).should be true
      parent_configuration_two.is_child?( parent_configuration ).should be false
      parent_configuration_two.is_child?( child_configuration ).should be true
      child_configuration.is_child?( parent_configuration ).should be false
      child_configuration.is_child?( parent_configuration_two ).should be false
    end
  end

  ################
  #  is_parent?  #
  ################

  context '#is_parent?' do
    it 'reports if it is a parent' do
      parent_configuration.is_parent?( parent_configuration_two ).should be false
      parent_configuration.is_parent?( child_configuration ).should be false
      parent_configuration_two.is_parent?( parent_configuration ).should be true
      parent_configuration_two.is_parent?( child_configuration ).should be false
      child_configuration.is_parent?( parent_configuration ).should be true
      child_configuration.is_parent?( parent_configuration_two ).should be true
    end
  end

  ############
  #  value=  #
  ############

  context '#value=' do
    before( :each ) { child_configuration }
    it 'transforms the cascade value' do
      parent_configuration.value = 'value'
      parent_configuration.value.should == 'value'
      parent_configuration_two.value.should == 'value2'
      child_configuration.value.should == 'value1'
    end
  end
  
end
