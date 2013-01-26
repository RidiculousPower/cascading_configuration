
require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

require_relative '../module_shared_examples.rb'

describe ::CascadingConfiguration::Core::Module::InheritingValues do

  let( :ccm ) { ::CascadingConfiguration::Core::Module::InheritingValues.new( :setting ) }
  
  it_behaves_like :configuration_module

end
