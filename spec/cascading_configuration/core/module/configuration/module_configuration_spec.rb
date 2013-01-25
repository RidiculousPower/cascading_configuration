
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Module.new.name( :ModuleInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Core::Module::Configuration::ModuleConfiguration }

  it_behaves_like ::CascadingConfiguration::Core::Module::Configuration

end
