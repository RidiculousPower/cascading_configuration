
require_relative 'module/cascading_method_shared_examples.rb'

require_relative '../helpers/configuration_module.rb'

require_relative '../support/named_class_and_module.rb'

shared_examples_for :configuration_module do
  
  let( :instance ) { ::CascadingConfiguration::Module.new( ccm_name, *ccm_aliases ).name( :Instance ) }
  let( :ccm ) do
    ccm_instance = ::Module.new.name( :CCM )
    ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( ccm_instance, instance )
    ccm_instance
  end
  let( :ccm_name ) { :setting }
  let( :ccm_aliases ) { [ '' ] }
  
  ##################################################################################################
  #   private ######################################################################################
  ##################################################################################################
  
  ###########################
  #  cascading_method_name  #
  ###########################
  
  context '#cascading_method_name' do
    let( :cascading_method_name ) { instance.module_eval { cascading_method_name( 'some_name' ) } }
    it 'can return a cascading method name for a base name' do
      cascading_method_name.should == 'attr_some_name'
    end
  end

  ###########################
  #  singleton_method_name  #
  ###########################

  context '#singleton_method_name' do
    let( :singleton_method_name ) { instance.module_eval { singleton_method_name( 'some_name' ) } }
    it 'can return a singleton method name for a base name' do
      singleton_method_name.should == 'attr_singleton_some_name'
    end
  end

  ########################
  #  module_method_name  #
  ########################

  context '#module_method_name' do
    let( :module_method_name ) { instance.module_eval { module_method_name( 'some_name' ) } }
    it 'can return a module method name for a base name' do
      module_method_name.should == 'attr_module_some_name'
    end
  end

  #######################
  #  class_method_name  #
  #######################

  context '#class_method_name' do
    let( :class_method_name ) { instance.module_eval { class_method_name( 'some_name' ) } }
    it 'can return a class method name for a base name' do
      class_method_name.should == 'attr_class_some_name'
    end
  end

  ##########################
  #  instance_method_name  #
  ##########################

  context '#instance_method_name' do
    let( :instance_method_name ) { instance.module_eval { instance_method_name( 'some_name' ) } }
    it 'can return an instance method name for a base name' do
      instance_method_name.should == 'attr_instance_some_name'
    end
  end

  ################################
  #  local_instance_method_name  #
  ################################

  context '#local_instance_method_name' do
    let( :local_instance_method_name ) { instance.module_eval { local_instance_method_name( 'some_name' ) } }
    it 'can return a local instance method name for a base name' do
      local_instance_method_name.should == 'attr_local_some_name'
    end
  end

  ########################
  #  object_method_name  #
  ########################

  context '#object_method_name' do
    let( :object_method_name ) { instance.module_eval { object_method_name( 'some_name' ) } }
    it 'can return an object method name for a base name' do
      object_method_name.should == 'attr_object_some_name'
    end
  end

  ##################################
  #  define_configuration_definer  #
  ##################################

  context '#define_configuration_definer' do
    before :each do
      _base_name = base_name
      _alias_names = alias_names
      _configuration_type = configuration_type
      instance.module_eval { define_configuration_definer( _base_name, _alias_names, _configuration_type ) }
    end
    let( :configuration_definer_args ) { [ base_name, alias_names, configuration_type, ccm ] }
    context 'for :all' do
      it_behaves_like :singleton_and_instance_method do
        let( :base_name ) { :all_base }
        let( :alias_names ) { [ :all_other ] }
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end
    context 'for :singleton' do
      it_behaves_like :singleton_method do
        let( :base_name ) { :singleton_base }
        let( :alias_names ) { [ :singleton_other ] }
        let( :method_name ) { :attr_singleton_setting }
        let( :method_aliases ) { [ :attr_singleton_configuration ] }
      end
    end
    context 'for :module' do
      it_behaves_like :singleton_method do
        let( :base_name ) { :module_base }
        let( :alias_names ) { [ :module_other ] }
        let( :method_name ) { :attr_singleton_setting }
        let( :method_aliases ) { [ :attr_singleton_configuration ] }
      end
    end
    context 'for :class' do
      it_behaves_like :singleton_method do
        let( :base_name ) { :class_base }
        let( :alias_names ) { [ :class_other ] }
        let( :method_name ) { :attr_singleton_setting }
        let( :method_aliases ) { [ :attr_singleton_configuration ] }
      end
    end
    context 'for :instance' do
      it_behaves_like :instance_method do
        let( :base_name ) { :instance_base }
        let( :alias_names ) { [ :instance_other ] }
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end
    context 'for :local_instance' do
      it_behaves_like :local_instance_method do
        let( :base_name ) { :local_instance_base }
        let( :alias_names ) { [ :local_instance_other ] }
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end
    context 'for :object' do
      it_behaves_like :object_method do
        let( :base_name ) { :object_base }
        let( :alias_names ) { [ :object_other ] }
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end
    
  end
  
  ##################################################################################################
  #   public #######################################################################################
  ##################################################################################################
  
  ######################
  #  module_type_name  #
  ######################

  context '#module_type_name' do
    it 'can initialize with a base name for a default encapsulation and with aliases' do
      instance.module_type_name.should be ccm_name
    end
  end
  
  ##############################
  #  module_type_name_aliases  #
  ##############################

  context '#module_type_name_aliases' do
    it 'can initialize with a base name for a default encapsulation and with aliases' do
      instance.module_type_name_aliases.should == ccm_aliases
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
      before( :each ) { instance.define_cascading_definition_method( base_name, *alias_names ) }
      it_behaves_like :singleton_and_instance_method do
        let( :method_name ) { :attr_setting }
        let( :method_aliases ) { [ :attr_configuration ] }
      end
    end

    ########################################
    #  define_singleton_definition_method  #
    ########################################

    context '#define_singleton_definition_method' do
      before( :each ) { instance.define_singleton_definition_method( base_name, *alias_names ) }
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
        instance.method( definer_method ).should == instance.method( definer_alias )
      end
    end

    #####################################
    #  define_module_definition_method  #
    #####################################

    context '#define_module_definition_method' do
      let( :definer_method ) { :define_module_definition_method }
      let( :definer_alias ) { :define_singleton_definition_method }
      it 'aliases #define_singleton_definition_method' do
        instance.method( definer_method ).should == instance.method( definer_alias )
      end
    end

    #######################################
    #  define_instance_definition_method  #
    #######################################

    context '#define_instance_definition_method' do
      before( :each ) { instance.define_instance_definition_method( base_name, *alias_names ) }
      it_behaves_like :instance_method do
        let( :method_name ) { :attr_instance_setting }
        let( :method_aliases ) { [ :attr_instance_configuration ] }
      end
    end

    #############################################
    #  define_local_instance_definition_method  #
    #############################################
  
    context '#define_local_instance_definition_method' do
      before( :each ) { instance.define_local_instance_definition_method( base_name, *alias_names ) }
      it_behaves_like :local_instance_method do
        let( :method_name ) { :attr_local_setting }
        let( :method_aliases ) { [ :attr_local_configuration ] }
      end
    end
  
    #####################################
    #  define_object_definition_method  #
    #####################################

    context '#define_object_definition_method' do
      before( :each ) { instance.define_object_definition_method( base_name, *alias_names ) }
      it_behaves_like :object_method do
        let( :method_name ) { :attr_object_setting }
        let( :method_aliases ) { [ :attr_object_configuration ] }
      end
    end
  
    #########################################
    #  define_cascading_definition_methods  #
    #########################################
  
    context '#define_cascading_definition_methods' do
      before( :each ) { instance.define_cascading_definition_methods( base_name, *alias_names ) }
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
      it_behaves_like :local_instance_method do
        let( :method_name ) { :attr_local_setting }
        let( :method_aliases ) { [ :attr_local_configuration ] }
      end
      it_behaves_like :object_method do
        let( :method_name ) { :attr_object_setting }
        let( :method_aliases ) { [ :attr_object_configuration ] }
      end
    end
  end

end
