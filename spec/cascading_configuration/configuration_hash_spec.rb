
require_relative '../../lib/cascading_configuration.rb'

require_relative '../support/named_class_and_module.rb'

describe CascadingConfiguration::ConfigurationHash do

  let( :include_extend_subclass_instance ) { :include }
  
  let( :parent_configuration_instance ) { ::Module.new.name( :ParentModuleConfigurationInstance ) }
  let( :child_configuration_instance ) { ::Module.new.name( :ChildModuleConfigurationInstance ) }
  let( :other_configuration_instance ) { ::Module.new.name( :OtherModuleConfigurationInstance ) }
  
  let( :configuration_module ) { ::CascadingConfiguration::Module.new( 'config_module' ) }
  
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration }
  
  let( :cascade_type_A ) { :singleton_and_instance }
  let( :cascade_type_B ) { :singleton_and_instance }

  let( :configuration_A ) { configuration_class.new( parent_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  let( :configuration_B ) { configuration_class.new( parent_configuration_instance, cascade_type_B, configuration_module, :configuration_B ) }

  let( :child_configuration_A ) { configuration_class.new( child_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  
  let( :hash_instance ) { parent_hash_instance }
  let( :parent_hash_instance ) do
    parent_hash = ::CascadingConfiguration::ConfigurationHash.new( nil, parent_configuration_instance )
    parent_hash[ :configuration_A ] = configuration_A
    parent_hash[ :configuration_B ] = configuration_B
    _include_extend_subclass_instance = include_extend_subclass_instance
    parent_hash
  end
  let( :child_hash_instance ) do
    child_hash = ::CascadingConfiguration::ConfigurationHash.new( nil, child_configuration_instance )
    _include_extend_subclass_instance = include_extend_subclass_instance
    child_hash.instance_eval do
      @include_extend_subclass_instance[ :configuration_A ] = _include_extend_subclass_instance
      @include_extend_subclass_instance[ :configuration_B ] = _include_extend_subclass_instance
    end
    child_hash
  end
  let( :other_hash_instance ) do
    other_hash = ::CascadingConfiguration::ConfigurationHash.new( nil, child_configuration_instance )
    other_hash[ :configuration_A ] = other_configuration_A
    other_hash[ :configuration_B ] = other_configuration_B
    other_hash
  end
  let( :other_configuration_A ) { configuration_class.new( other_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  let( :other_configuration_B ) { configuration_class.new( other_configuration_instance, cascade_type_B, configuration_module, :configuration_B ) }
  
  ###################
  #  cascade_model  #
  ###################
  
  context '#cascade_model' do
    context ':include' do
      let( :include_extend_subclass_instance ) { :include }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
      end
    end
    context ':subclass' do
      let( :include_extend_subclass_instance ) { :subclass }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
      end
    end
    context ':extend' do
      let( :include_extend_subclass_instance ) { :extend }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :instance_to_singleton
      end
    end
    context ':instance' do
      let( :include_extend_subclass_instance ) { :instance }
      context 'instance of Object' do
        let( :child_configuration_instance ) { ::Object.new.name( :ObjectChildConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :instance_to_instance
        end
      end
      context 'instance of class inheriting from Module' do
        let( :child_configuration_instance ) { ::Class.new( ::Module ).name( :ClassInheritingFromModuleChildConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :instance_to_singleton
        end
      end
    end
    context ':singleton_to_singleton' do
      let( :include_extend_subclass_instance ) { :singleton_to_singleton }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton
      end
    end
    context 'nil' do
      let( :include_extend_subclass_instance ) { nil }
      context 'parent instance is module' do
        context 'child instance is module' do
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is class' do
          let( :child_configuration_instance ) { ::Class.new.name( :ChildClassConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is instance of Object' do
          let( :child_configuration_instance ) { ::Object.new.name( :ChildObjectConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :instance_to_instance
          end
        end
      end
      context 'parent instance is class' do
        let( :parent_configuration_instance ) { ::Class.new.name( :ParentClassConfigurationInstance ) }
        context 'child instance is class' do
          let( :child_configuration_instance ) { ::Class.new.name( :ChildClassConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is instance' do
          let( :child_configuration_instance ) { ::Object.new.name( :ChildObjectConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :instance_to_instance
          end
        end
      end
      context 'parent instance is instance' do
        let( :parent_configuration_instance ) { ::Object.new.name( :ParentObjectConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance, :configuration_A ).should == :singleton_to_singleton_and_instance_to_instance
        end
      end
    end
    
  end
  
  ##################################
  #  register_child_configuration  #
  ##################################

  context '#register_child_configuration' do
    before :each do
      child_hash_instance.register_child_configuration( :configuration_A, configuration_A )
    end
    context 'configuration does not already exist' do
      it 'will create a new child configuration' do
        child_hash_instance[ :configuration_A ].should be_a configuration_class
      end
    end
    context 'configuration already exists' do
      before :each do
        child_hash_instance[ :configuration_A ] = child_configuration_A
        child_hash_instance.register_child_configuration( :configuration_A, configuration_A )
      end
      it 'will register existing configuration as child' do
        child_hash_instance[ :configuration_A ].parent.should be configuration_A
      end
    end
  end

  ########################
  #  child_pre_set_hook  #
  ########################
  
  context '#child_pre_set_hook' do
    before :each do
      _configuration_A = configuration_A
      _parent_hash_instance = parent_hash_instance
      child_hash_instance.instance_eval do
        child_pre_set_hook( :configuration_A, _configuration_A, _parent_hash_instance )
      end
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be configuration_A
    end
  end
  
  #####################
  #  register_parent  #
  #####################
  
  context '#register_parent' do
    before :each do
      child_hash_instance.register_parent( parent_hash_instance )
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
      child_hash_instance[ :configuration_B ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be configuration_A
      child_hash_instance[ :configuration_B ].parent.should be configuration_B
    end
  end

  #######################
  #  unregister_parent  #
  #######################
  
  context '#unregister_parent' do
    before :each do
      child_hash_instance.register_parent( parent_hash_instance )
      child_hash_instance.unregister_parent( parent_hash_instance )
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
      child_hash_instance[ :configuration_B ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be nil
      child_hash_instance[ :configuration_B ].parent.should be nil
    end
  end

  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    before :each do
      child_hash_instance.register_parent( parent_hash_instance )
      child_hash_instance.replace_parent( parent_hash_instance, other_hash_instance )
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
      child_hash_instance[ :configuration_B ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be other_configuration_A
      child_hash_instance[ :configuration_B ].parent.should be other_configuration_B
    end
  end
  
end
