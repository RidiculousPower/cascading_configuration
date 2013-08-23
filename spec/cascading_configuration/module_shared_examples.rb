# -*- encoding : utf-8 -*-

require_relative 'module/cascading_method_shared_examples.rb'

require_relative '../helpers/configuration_module.rb'

require_relative '../support/named_class_and_module.rb'

shared_examples_for :configuration_module do

  ######################
  #  module_type_name  #
  ######################

  context '#module_type_name' do
    it 'can initialize with a base name for a default encapsulation and with aliases' do
      ccm.module_type_name.should be ccm_name
    end
  end

  ##############################
  #  module_type_name_aliases  #
  ##############################

  context '#module_type_name_aliases' do
    it 'can initialize with a base name for a default encapsulation and with aliases' do
      ccm.module_type_name_aliases.should == ccm_aliases
    end
  end
  
  ###########################
  #  cascading_method_name  #
  ###########################
  
  context '#cascading_method_name' do
    let( :cascading_method_name ) { ccm.cascading_method_name( 'some_name' ) }
    it 'can return a cascading method name for a base name' do
      cascading_method_name.should == 'attr_some_name'
    end
  end

  ###########################
  #  singleton_method_name  #
  ###########################

  context '#singleton_method_name' do
    let( :singleton_method_name ) { ccm.singleton_method_name( 'some_name' ) }
    it 'can return a singleton method name for a base name' do
      singleton_method_name.should == 'attr_singleton_some_name'
    end
  end

  ########################
  #  module_method_name  #
  ########################

  context '#module_method_name' do
    let( :module_method_name ) { ccm.module_method_name( 'some_name' ) }
    it 'can return a module method name for a base name' do
      module_method_name.should == 'attr_module_some_name'
    end
  end

  #######################
  #  class_method_name  #
  #######################

  context '#class_method_name' do
    let( :class_method_name ) { ccm.class_method_name( 'some_name' ) }
    it 'can return a class method name for a base name' do
      class_method_name.should == 'attr_class_some_name'
    end
  end

  ##########################
  #  instance_method_name  #
  ##########################

  context '#instance_method_name' do
    let( :instance_method_name ) { ccm.instance_method_name( 'some_name' ) }
    it 'can return an instance method name for a base name' do
      instance_method_name.should == 'attr_instance_some_name'
    end
  end

  ########################
  #  object_method_name  #
  ########################

  context '#object_method_name' do
    let( :object_method_name ) { ccm.object_method_name( 'some_name' ) }
    it 'can return a local instance method name for a base name' do
      object_method_name.should == 'attr_object_some_name'
    end
  end

  ################################
  #  local_instance_method_name  #
  ################################

  context '#local_instance_method_name' do
    let( :local_instance_method_name ) { ccm.local_instance_method_name( 'some_name' ) }
    it 'can return an object method name for a base name' do
      local_instance_method_name.should == 'attr_local_instance_some_name'
    end
  end

  context '=========  Defining Cascading Methods  ========' do

    let( :base_name ) { :setting }
    let( :alias_names ) { [ :configuration ] }
    let( :configuration_definer_args ) { [ method_name, method_aliases, configuration_type, ccm ] }
    
    ########################################
    #  define_cascading_definition_method  #
    ########################################
  
    context '#define_cascading_definition_method' do
      before( :each ) { ccm.define_cascading_definition_method( base_name, *alias_names ) }
      it_behaves_like :singleton_and_instance_method do
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end

    ########################################
    #  define_singleton_definition_method  #
    ########################################

    context '#define_singleton_definition_method' do
      before( :each ) { ccm.define_singleton_definition_method( base_name, *alias_names ) }
      it_behaves_like :singleton_method do
        let( :method_name ) { :attr_singleton_setting }
        let( :method_aliases ) { [ :attr_singleton_configuration ] }
      end
    end
    
    #####################################
    #  define_class_definition_method  #
    #####################################

    context '#define_class_definition_method' do
      let( :definer_method ) { :define_class_definition_method }
      let( :definer_alias ) { :define_singleton_definition_method }
      it 'aliases #define_singleton_definition_method' do
        ccm.method( definer_method ).should == ccm.method( definer_alias )
      end
    end

    #####################################
    #  define_module_definition_method  #
    #####################################

    context '#define_module_definition_method' do
      let( :definer_method ) { :define_module_definition_method }
      let( :definer_alias ) { :define_singleton_definition_method }
      it 'aliases #define_singleton_definition_method' do
        ccm.method( definer_method ).should == ccm.method( definer_alias )
      end
    end

    #######################################
    #  define_instance_definition_method  #
    #######################################

    context '#define_instance_definition_method' do
      before( :each ) { ccm.define_instance_definition_method( base_name, *alias_names ) }
      it_behaves_like :instance_method do
        let( :method_name ) { :attr_instance_setting }
        let( :method_aliases ) { [ :attr_instance_configuration ] }
      end
    end

    #####################################
    #  define_object_definition_method  #
    #####################################
  
    context '#define_object_definition_method' do
      before( :each ) { ccm.define_object_definition_method( base_name, *alias_names ) }
      it_behaves_like :object_method do
        let( :method_name ) { :attr_object_setting }
        let( :method_aliases ) { [ :attr_object_configuration ] }
      end
    end
  
    ##############################################
    #  define_local_instance_definition_method  #
    ##############################################

    context '#define_local_instance_definition_method' do
      before( :each ) { ccm.define_local_instance_definition_method( base_name, *alias_names ) }
      it_behaves_like :local_instance_method do
        let( :method_name ) { :attr_local_instance_setting }
        let( :method_aliases ) { [ :attr_local_instance_configuration ] }
      end
    end
  
    #########################################
    #  define_cascading_definition_methods  #
    #########################################
  
    context '#define_cascading_definition_methods' do
      before( :each ) { ccm.define_cascading_definition_methods( base_name, *alias_names ) }
      it_behaves_like :singleton_and_instance_method do
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
      it_behaves_like :singleton_method do
        let( :method_name ) { :attr_singleton_setting }
        let( :method_aliases ) { [ :attr_singleton_configuration ] }
      end
      it_behaves_like :instance_method do
        let( :method_name ) { :attr_instance_setting }
        let( :method_aliases ) { [ :attr_instance_configuration ] }
      end
      it_behaves_like :object_method do
        let( :method_name ) { :attr_object_setting }
        let( :method_aliases ) { [ :attr_object_configuration ] }
      end
      it_behaves_like :local_instance_method do
        let( :method_name ) { :attr_local_instance_setting }
        let( :method_aliases ) { [ :attr_local_instance_configuration ] }
      end
    end
  end

end
