# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

require_relative '../configuration_shared.rb'
require_relative '../configuration_setup.rb'

describe ::CascadingConfiguration::Module::InheritingValues::Configuration do
  
  setup_configuration_tests
  
  let( :configuration_class ) { ::CascadingConfiguration::Module::InheritingValues::Configuration }
  
  it_behaves_like ::CascadingConfiguration::Module::Configuration

  #####################
  #  register_parent  #
  #####################
  
  context '#register_parent' do
    it 'will keep existing parent if new parent is parent of existing parent' do
      child_configuration.register_parent( parent_configuration )
      child_configuration.parent.should be parent_configuration_two
    end
  end

  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  context '#permits_multiple_parents?' do
    it 'does not permit multiple parents by default' do
      parent_configuration.permits_multiple_parents?.should be false
    end
  end

  ############
  #  parent  #
  ############
  
  context '#parent' do
    it 'can register/report a parent, which is implied by initializing with an ancestor' do
      child_configuration.parent.should be parent_configuration_two
    end
  end
  
  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    it 'can replace a parent' do
      child_configuration.replace_parent( parent_configuration )
      child_configuration.parent.should be parent_configuration
    end
  end

  #######################
  #  unregister_parent  #
  #######################

  context '#unregister_parent' do
    it 'can remove a parent' do
      child_configuration.unregister_parent
      child_configuration.parent.should be nil
    end
  end

  ##################
  #  has_parents?  #
  ##################

  context '#has_parents?' do
    context 'when no parents' do
      it 'a child can report it has parents' do
        child_configuration.has_parents?.should be true
      end
    end
    context 'when it has parents' do
      it 'a parent can report it has no parents' do
        parent_configuration.has_parents?.should be false
      end
    end
  end

  ################
  #  is_parent?  #
  ################
  
  context '#is_parent?' do
    it 'can report if an instance is a parent' do
      child_configuration.is_parent?( parent_configuration ).should be true
    end
  end
  
  ################################
  #  match_parent_configuration  #
  ################################

  context '#match_parent_configuration' do
    it 'can match a parent for a condition' do
      child_configuration.match_parent_configuration do |this_parent|
        this_parent.equal?( parent_configuration )
      end.should be parent_configuration
    end
  end

  ###########
  #  value  #
  ###########

  context '#value' do
    it 'matches value by searching upward for first match' do
      parent_configuration.value = :some_value
      child_configuration.value.should be :some_value
    end
  end
  
end
