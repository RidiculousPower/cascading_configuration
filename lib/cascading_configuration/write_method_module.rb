# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::WriteMethodModule < ::Module

  ################
  #  initialize  #
  ################

  def initialize( controller, write_accessor, configuration_name )
    
    @controller         = controller
    @read_accessor      = write_accessor
    @configuration_name = configuration_name
    
    # instance.write_accessor calls configuration.value=
    define_method( write_accessor ) { |value| controller.configuration( self, configuration_name ).value = value }
    
  end

end
