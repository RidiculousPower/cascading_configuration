
def setup_module_tests

  let( :instance ) { ::CascadingConfiguration::Module.new( ccm_name, *ccm_aliases ).name( :Instance ) }
  let( :ccm ) do
    ccm_instance = ::Module.new.name( :CCM )
    ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( ccm_instance, instance )
    ccm_instance
  end
  let( :ccm_name ) { :setting }
  let( :ccm_aliases ) { [ '' ] }
  
end
