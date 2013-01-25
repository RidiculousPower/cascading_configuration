
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration::InstanceConfiguration do

  let( :instance ) { ::Object.new.name( :ObjectInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Core::Module::Configuration::InstanceConfiguration }

  it_behaves_like ::CascadingConfiguration::Core::Module::Configuration

end
