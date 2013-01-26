
require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Module::Configuration::InstanceConfiguration do

  let( :instance ) { ::Object.new.name( :ObjectInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration::InstanceConfiguration }

  it_behaves_like ::CascadingConfiguration::Module::Configuration

end
