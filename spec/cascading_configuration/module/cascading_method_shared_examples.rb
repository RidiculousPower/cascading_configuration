# -*- encoding : utf-8 -*-

shared_examples_for :singleton_and_instance_method do
  let( :configuration_type ) { :singleton_and_instance }
  it 'will define configuration with alias names as a cascading method' do
    ccm.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :singleton_method do
  let( :configuration_type ) { :singleton }
  it 'will define configuration with alias names as a cascading module method' do
    ccm.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :instance_method do
  let( :configuration_type ) { :instance }
  it 'will define configuration with alias names as a cascading instance method' do
    ccm.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :object_method do
  let( :configuration_type ) { :object }
  it 'will define configuration with alias names as a non-cascading local instance method and cascading instance method' do
    ccm.should have_defined_configuration( *configuration_definer_args )
  end
end

shared_examples_for :local_instance_method do
  let( :configuration_type ) { :local_instance }
  it 'will define configuration with alias names as a non-cascading local instance method' do
    ccm.should have_defined_configuration( *configuration_definer_args )
  end
end
