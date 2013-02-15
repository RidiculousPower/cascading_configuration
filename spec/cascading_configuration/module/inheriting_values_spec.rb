
require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

require_relative '../module_setup.rb'
require_relative '../module_shared_examples.rb'

describe ::CascadingConfiguration::Module::InheritingValues do
  
  setup_module_tests
  
  it_behaves_like :configuration_module do
    let( :instance ) { ::CascadingConfiguration::Module::InheritingValues.new( ccm_name, *ccm_aliases ).name( :InheritingValuesInstance ) }
  end

end
