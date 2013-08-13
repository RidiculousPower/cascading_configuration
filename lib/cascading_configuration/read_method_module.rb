# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::Controller::ReadMethodModule < ::Module
  
  ################
  #  initialize  #
  ################

  def initialize( read_accessor, configuration_name )
    
    # instance.read_accessor returns configuration.value
    define_method( read_accessor ) { ::CascadingConfiguration.configuration( self, configuration_name ).value }
    # instance.•read_accessor returns configuration
    define_method( '•' << read_accessor.to_s ) { ::CascadingConfiguration.configuration( self, configuration_name ) }
    
  end
  
end
