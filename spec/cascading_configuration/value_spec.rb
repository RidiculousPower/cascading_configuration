# -*- encoding : utf-8 -*-

require_relative '../../lib/cascading_configuration.rb'

require_relative '../support/named_class_and_module.rb'

describe CascadingConfiguration::Value do

  let( :module_instance ) do
    module_instance = ::Module.new.name( :ValueModuleInstance )
    module_instance.extend( ::CascadingConfiguration::Value )
    module_instance.attr_value( :cascading_value ) { |value| value + 1 }
    module_instance
  end
  
  let( :sub_module_instance ) do
    sub_module_instance = ::Module.new.name( :ValueSubModuleInstance )
    _module_instance = module_instance
    sub_module_instance.module_eval { include _module_instance }
    sub_module_instance
  end
  
  let( :class_instance ) do
    class_instance = ::Class.new.name( :ValueClassInstance )
    _sub_module_instance = sub_module_instance
    class_instance.module_eval { include _sub_module_instance }
    class_instance
  end
  
  let( :subclass ) { ::Class.new( class_instance ).name( :ValueSubclassInstance ) }
  
  let( :instance ) { subclass.new }
  
  let( :explicit_instance_from_class ) do
    explicit_instance_from_class = ::Object.new
    explicit_instance_from_class.extend( class_instance.•cascading_value.read_method_module,
                                         class_instance.•cascading_value.write_method_module )
    ::CascadingConfiguration.register_parent( explicit_instance_from_class, class_instance )
    explicit_instance_from_class
  end

  let( :explicit_instance_from_instance ) do
    explicit_instance_from_instance = ::Object.new
    explicit_instance_from_instance.extend( subclass.•cascading_value.read_method_module,
                                            subclass.•cascading_value.write_method_module )
    ::CascadingConfiguration.register_parent( explicit_instance_from_instance, instance )
    explicit_instance_from_instance
  end
  
  ################
  #  attr_value  #
  ################

  context '#attr_value' do
    before( :each ) { sub_module_instance }
    it 'creates a cascading value' do
      module_instance.cascading_value = 1
      sub_module_instance.cascading_value.should == 2
      class_instance.cascading_value.should == 3
      subclass.cascading_value.should == 4
      instance.cascading_value.should == 5
      explicit_instance_from_class.cascading_value.should == 4
      explicit_instance_from_instance.cascading_value.should == 6
    end
  end

end
