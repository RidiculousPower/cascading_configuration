
require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Module::Configuration::ModuleConfiguration do

  let( :instance ) { ::Class.new( ::Module ).name( :ClassInheritingFromModuleInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration::ClassInheritingFromModuleConfiguration }

  it_behaves_like ::CascadingConfiguration::Module::Configuration

end
