
###
# A Hash subclass used to store configurations by object.__id__.#hash 
#   instead of object#hash, and to automatically create a nested hash
#   when an object is requested whose ID is not yet existing.
#
class ::CascadingConfiguration::Core::AutoNestingIDHash < ::Hash
  
  ################
  #  initialize  #
  ################
  
  def initialize( nested_class = ::Hash, default_value = nil )
  
    @nested_class = nested_class
    
    super( default_value )
    
  end

  ##############
  #  store_id  #
  ##############
  
  alias_method :store_id, :[]=
  
  #########
  #  []=  #
  #########
  
  def []=( object, nested_hash )
    
    return super( object.__id__, nested_hash )
    
  end

  ############
  #  get_id  #
  ############
  
  alias_method :get_id, :[]

  ########
  #  []  #
  ########
  
  def []( object )
    
    nested_hash = nil
    
    object_id = object.__id__
    
    unless nested_hash = super( object_id )
      nested_hash = @nested_class.new
      store_id( object_id, nested_hash )
    end
    
    return nested_hash
    
  end
  
  ##############
  #  has_key?  #
  ##############
  
  def has_key?( object )
    
    return super( object.__id__ )
    
  end
  
end
