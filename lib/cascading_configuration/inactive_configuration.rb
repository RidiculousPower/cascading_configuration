
::CascadingConfiguration::InactiveConfiguration = ::Struct.new( :parent,
                                                                :configuration_module,
                                                                :configuration_name,
                                                                :write_accessor,
                                                                :parsed_args,
                                                                :block ) do

  #########################
  #  new_active_instance  #
  #########################
  
  def new_active_instance( for_instance, event )
    
    return case parent

      when nil, ::CascadingConfiguration::InactiveConfiguration
        configuration_module.class::Configuration.new( for_instance,
                                                       configuration_module,
                                                       configuration_name,
                                                       write_accessor || configuration_name,
                                                       & block )
      
      else
        parent.class.new_inheriting_instance( for_instance, parent, event, & block )
    end
    
  end
  
end