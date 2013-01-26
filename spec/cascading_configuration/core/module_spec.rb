
require_relative '../../../lib/cascading_configuration.rb'

require_relative 'module_shared_examples.rb'

describe ::CascadingConfiguration::Core::Module do
  
  it_behaves_like :configuration_module
  
end

