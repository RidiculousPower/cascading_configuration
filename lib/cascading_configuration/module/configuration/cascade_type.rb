
class ::CascadingConfiguration::Module::Configuration::CascadeType
  
  ################
  #  initialize  #
  ################
  
  ###
  # @overload initialize( type_name, method_type, ..., & cascade_test_block )
  #
  #   @param [Symbol,String] type_name
  #   
  #          Name of cascade type.
  #   
  #   @param [:singleton,:instance,:class,:module,:local_instance,:object] method_type
  #   
  #          Where methods should be defined for this configuration.
  #
  #   @yield cascade_test_block
  #   
  #          Block to test whether cascade to instance should occur.
  #   
  #     @yieldparam [Object] instance
  #   
  #                 Instance to which cascade would occur.
  #   
  #     @yieldreturn [true,false]
  #   
  #                  Whether cascade should occur.        
  #
  def initialize( type_name, *method_types, & cascade_test_block )
    
    @name = type_name
    
    @block = cascade_test_block
    
  end

  ##########
  #  name  #
  ##########
  
  ###
  # Name of cascade type.
  #
  # @!attribute [r] name
  #
  # @return [Symbol,String] Name of cascade type.
  #
  attr_reader :name

  ###########
  #  block  #
  ###########
  
  ###
  # Block to test whether cascade should occur.
  #
  # @!attribute [r] block
  #
  # @return [Proc] Block to test whether cascade should occur.
  #
  attr_reader :block
  
end
