# -*- encoding : utf-8 -*-

def setup_module_tests

  let( :ccm ) do
    ccm = ::CascadingConfiguration::Module.new( ccm_name, *ccm_aliases ).name( :Instance )
    ::CascadingConfiguration.register_configuration_module( ccm )
    ccm
  end
  let( :ccm_name ) { :setting }
  let( :ccm_aliases ) { [ '' ] }
  let( :ccm_block ) { nil }
  
end
