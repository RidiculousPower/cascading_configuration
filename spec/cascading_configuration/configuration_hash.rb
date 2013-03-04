# -*- encoding : utf-8 -*-

shared_examples_for :configuration_hash do

  let( :include_extend_subclass_instance ) { :include }
  
  let( :parent_configuration_instance ) { ::Module.new.name( :ParentModuleConfigurationInstance ) }
  let( :child_configuration_instance ) { ::Module.new.name( :ChildModuleConfigurationInstance ) }
  let( :other_configuration_instance ) { ::Module.new.name( :OtherModuleConfigurationInstance ) }
    
  let( :cascade_type_A ) { :singleton_and_instance }
  let( :cascade_type_B ) { :singleton_and_instance }

  let( :configuration_A ) { configuration_class.new( parent_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  let( :configuration_B ) { configuration_class.new( parent_configuration_instance, cascade_type_B, configuration_module, :configuration_B ) }

  let( :child_configuration_A ) { configuration_class.new( child_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  
  let( :hash_instance ) { parent_hash_instance }
  let( :parent_hash_instance ) do
    parent_hash = ::CascadingConfiguration::ConfigurationHash.new( parent_configuration_instance )
    parent_hash[ :configuration_A ] = configuration_A
    parent_hash[ :configuration_B ] = configuration_B
    parent_hash
  end
  let( :child_hash_instance ) do
    child_hash = ::CascadingConfiguration::ConfigurationHash.new( child_configuration_instance )
    child_hash.register_parent( parent_hash_instance, include_extend_subclass_instance )
    child_hash
  end
  let( :other_hash_instance ) do
    other_hash = ::CascadingConfiguration::ConfigurationHash.new( child_configuration_instance )
    other_hash[ :configuration_A ] = other_configuration_A
    other_hash[ :configuration_B ] = other_configuration_B
    other_hash
  end
  let( :other_configuration_A ) { configuration_class.new( other_configuration_instance, cascade_type_A, configuration_module, :configuration_A ) }
  let( :other_configuration_B ) { configuration_class.new( other_configuration_instance, cascade_type_B, configuration_module, :configuration_B ) }
  
  #########################
  #  register_parent_key  #
  #########################
  
  context '#register_parent_key' do
    let( :inheriting_hash ) do
      child_hash_instance.register_parent( hash_instance, include_extend_subclass_instance )
      child_hash_instance
    end
    context 'configuration is :local_instance' do
      let( :cascade_type_A ) { :local_instance }
      it 'will not cascade' do
        inheriting_hash.has_key?( :configuration_A ).should be false
      end
    end
    context 'configuration is :object' do
      let( :cascade_type_A ) { :object }
      it 'will not cascade' do
        inheriting_hash.has_key?( :configuration_A ).should be false
      end
    end
    context 'child does not already have configuration' do
      it 'will create a new child configuration' do
        inheriting_hash[ :configuration_A ].should be_a configuration_A.class
      end
      it 'will register the parent configuration with the new child' do
        inheriting_hash[ :configuration_A ].parent.should be configuration_A if configuration_class.method_defined?( :parent )
      end
    end
    context 'child already has configuration' do
      let( :inheriting_hash ) do
        child_hash_instance[ :configuration_A ] = child_configuration_A
        child_hash_instance.register_parent( hash_instance, include_extend_subclass_instance )
        child_hash_instance.register_parent_key( hash_instance, :configuration_A )
        child_hash_instance
      end
      it 'will keep the original configuration' do
        inheriting_hash[ :configuration_A ].should be child_configuration_A
      end
      it 'will register the new parent configuration' do
        inheriting_hash[ :configuration_A ].parent.should be configuration_A if configuration_class.method_defined?( :parent )
      end
    end
  end
  
  ###################
  #  cascade_model  #
  ###################
  
  context '#cascade_model' do
    context ':include' do
      let( :include_extend_subclass_instance ) { :include }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
      end
    end
    context ':subclass' do
      let( :include_extend_subclass_instance ) { :subclass }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
      end
    end
    context ':extend' do
      let( :include_extend_subclass_instance ) { :extend }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance ).should == :instance_to_singleton
      end
    end
    context ':instance' do
      let( :include_extend_subclass_instance ) { :instance }
      context 'instance of Object' do
        let( :child_configuration_instance ) { ::Object.new.name( :ObjectChildConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance ).should == :instance_to_instance
        end
      end
      context 'instance of class inheriting from Module' do
        let( :child_configuration_instance ) { ::Class.new( ::Module ).name( :ClassInheritingFromModuleChildConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance ).should == :instance_to_singleton
        end
      end
    end
    context ':singleton_to_singleton' do
      let( :include_extend_subclass_instance ) { :singleton_to_singleton }
      it 'will return symbol describing model for cascading configuration' do
        child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton
      end
    end
    context 'nil' do
      let( :include_extend_subclass_instance ) { nil }
      context 'parent instance is module' do
        context 'child instance is module' do
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is class' do
          let( :child_configuration_instance ) { ::Class.new.name( :ChildClassConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is instance of Object' do
          let( :child_configuration_instance ) { ::Object.new.name( :ChildObjectConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance ).should == :instance_to_instance
          end
        end
      end
      context 'parent instance is class' do
        let( :parent_configuration_instance ) { ::Class.new.name( :ParentClassConfigurationInstance ) }
        context 'child instance is class' do
          let( :child_configuration_instance ) { ::Class.new.name( :ChildClassConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
          end
        end
        context 'child instance is instance' do
          let( :child_configuration_instance ) { ::Object.new.name( :ChildObjectConfigurationInstance ) }
          it 'will return symbol describing model for cascading configuration' do
            child_hash_instance.cascade_model( parent_hash_instance ).should == :instance_to_instance
          end
        end
      end
      context 'parent instance is instance' do
        let( :parent_configuration_instance ) { ::Object.new.name( :ParentObjectConfigurationInstance ) }
        it 'will return symbol describing model for cascading configuration' do
          child_hash_instance.cascade_model( parent_hash_instance ).should == :singleton_to_singleton_and_instance_to_instance
        end
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
        non_cascading_store( :configuration_A, child_pre_set_hook( :configuration_A, _configuration_A, _parent_hash_instance ) )
      end
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be configuration_A if configuration_class.method_defined?( :parent )
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
      child_hash_instance[ :configuration_A ].parent.should be configuration_A if configuration_class.method_defined?( :parent )
      child_hash_instance[ :configuration_B ].parent.should be configuration_B if configuration_class.method_defined?( :parent )
    end
  end

  #######################
  #  unregister_parent  #
  #######################
  
  context '#unregister_parent' do
    before :each do
      child_hash_instance.register_parent( parent_hash_instance )
      child_hash_instance.unregister_parent( parent_hash_instance ) if configuration_class.method_defined?( :unregister_parent )
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
      child_hash_instance[ :configuration_B ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be nil if configuration_class.method_defined?( :parent )
      child_hash_instance[ :configuration_B ].parent.should be nil if configuration_class.method_defined?( :parent )
    end
  end

  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    before :each do
      child_hash_instance.register_parent( parent_hash_instance )
      child_hash_instance.replace_parent( parent_hash_instance, other_hash_instance ) if configuration_class.method_defined?( :replace_parent )
    end
    it 'will inherit configurations as new child configurations' do
      child_hash_instance[ :configuration_A ].should be_a configuration_class
      child_hash_instance[ :configuration_B ].should be_a configuration_class
    end
    it 'child configurations will parent configuration as parent' do
      child_hash_instance[ :configuration_A ].parent.should be other_configuration_A if configuration_class.method_defined?( :parent )
      child_hash_instance[ :configuration_B ].parent.should be other_configuration_B if configuration_class.method_defined?( :parent )
    end
  end
  
end
