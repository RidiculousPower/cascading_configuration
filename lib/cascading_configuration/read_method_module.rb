# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ReadMethodModule < ::Module
  
  ################
  #  initialize  #
  ################

  def initialize( controller, configuration_name, read_accessor )
    
    @controller         = controller
    @read_accessor      = read_accessor
    @configuration_name = configuration_name
    
    # instance.read_accessor returns configuration.value
    define_method( read_accessor ) { controller.configuration( self, configuration_name ).value }
    # instance.•read_accessor returns configuration
    define_method( '•' << read_accessor.to_s ) { puts 'self: ' << self.name.to_s;controller.configuration( self, configuration_name ) }
    
  end
  
end
