# -*- encoding : utf-8 -*-

def setup_configuration_tests
  
  let( :configuration_name ) { :configuration_name }
  let( :configuration_write_name ) { :configuration_name= }

  let( :configuration_module ) do
    module_instance = ::Module.new.name( :ConfigurationModule )
    module_instance.module_eval do
      def self.controller
        return ::CascadingConfiguration
      end
    end
    module_instance
  end

  let( :parent_instance ) { ::Module.new.name( :ParentInstance ) }
  let( :parent_instance_two ) { ::Module.new.name( :ParentInstanceTwo ) }
  let( :child_instance ) { ::Module.new.name( :ChildInstance ) }
  
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration }
  let( :parent_configuration ) do
    configuration_class.new( parent_instance, 
                             configuration_module, 
                             configuration_name, 
                             configuration_write_name,
                             & parent_configuration_block )
  end
  let( :parent_configuration_two ) { configuration_class.new«inheriting_configuration»( parent_instance_two, 
                                                                                  parent_configuration,
                                                                                  :include,
                                                                                  & parent_two_configuration_block ) }
  let( :child_configuration ) { configuration_class.new«inheriting_configuration»( child_instance, 
                                                                             parent_configuration_two,
                                                                             :include,
                                                                             & child_configuration_block ) }
  
  let( :parent_configuration_block ) { nil }
  let( :parent_two_configuration_block ) { nil }
  let( :child_configuration_block ) { nil }
  
  let( :ccm_block ) { nil }

end
