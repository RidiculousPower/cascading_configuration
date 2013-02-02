
class ::CascadingConfiguration::Module::Configuration::CascadeType
  
  ################
  #  initialize  #
  ################
  
  ###
  # @param [Symbol,String] type_name
  #
  #        Name of cascade type.
  #
  # @yield cascade_test_block
  #
  #        Block to test whether cascade to instance should occur.
  #
  #   @yieldparam [Object] instance
  #
  #               Instance to which cascade would occur.
  #
  #   @yieldreturn [true,false]
  #
  #                Whether cascade should occur.        
  #
  def initialize( type_name, & cascade_test_block )
    
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
