
require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

require_relative 'configuration_shared.rb'
require_relative 'configuration_setup.rb'

describe ::CascadingConfiguration::Module::Configuration do
  
  setup_configuration_tests
  
  it_behaves_like ::CascadingConfiguration::Module::Configuration
  
  #####################
  #  register_parent  #
  #####################
  
  context '#register_parent' do
    it 'will keep existing parent if new parent is parent of existing parent' do
      child_configuration.register_parent( parent_configuration )
      child_configuration.parent.should be parent_configuration
    end
  end

  ################
  #  is_parent?  #
  ################
  
  context '#is_parent?' do
    it 'can report if an instance is a parent' do
      child_configuration.is_parent?( parent_configuration_two ).should be true
    end
  end
  
end
