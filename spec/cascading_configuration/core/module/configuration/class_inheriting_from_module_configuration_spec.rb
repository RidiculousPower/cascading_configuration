
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Class.new( ::Module ).name( :ClassInheritingFromModuleInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Core::Module::Configuration::ClassInheritingFromModuleConfiguration }

  it_behaves_like ::CascadingConfiguration::Core::Module::Configuration

end
