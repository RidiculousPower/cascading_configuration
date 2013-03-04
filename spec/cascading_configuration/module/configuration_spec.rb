# -*- encoding : utf-8 -*-

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
    end
  end
  
end
