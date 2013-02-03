
shared_examples_for :singleton_and_instance_method do
  let( :configuration_type ) { :singleton_and_instance }
  it 'will define configuration with alias names as a cascading method' do
    instance.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :singleton_method do
  let( :configuration_type ) { :singleton }
  it 'will define configuration with alias names as a cascading module method' do
    instance.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :instance_method do
  let( :configuration_type ) { :instance }
  it 'will define configuration with alias names as a cascading instance method' do
    instance.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :local_instance_method do
  let( :configuration_type ) { :local_instance }
  it 'will define configuration with alias names as a non-cascading local instance method' do
    instance.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :object_method do
  let( :configuration_type ) { :object }
  it 'will define configuration with alias names as a cascading object method' do
    instance.should have_defined_configuration( *configuration_definer_args )
  end
end