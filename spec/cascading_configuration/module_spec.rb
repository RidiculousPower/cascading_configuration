# -*- encoding : utf-8 -*-

require_relative '../../lib/cascading_configuration.rb'

require_relative 'module_setup.rb'
require_relative 'module_shared_examples.rb'

describe ::CascadingConfiguration::Module do
  
  setup_module_tests
  
  it_behaves_like :configuration_module
  
end

