
require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Module.new.name( :ModuleInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration::ModuleConfiguration }

  it_behaves_like ::CascadingConfiguration::Module::Configuration

end
