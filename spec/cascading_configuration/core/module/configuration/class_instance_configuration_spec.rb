
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Class.name( :ClassInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Core::Module::Configuration::ClassInstanceConfiguration }

  it_behaves_like ::CascadingConfiguration::Core::Module::Configuration

end
