
require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Class.name( :ClassInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration::ClassInstanceConfiguration }

  it_behaves_like ::CascadingConfiguration::Module::Configuration

end
