# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::WriteMethodModule < ::Module

  ################
  #  initialize  #
  ################

  def initialize( controller, configuration_name, write_accessor )

    @controller         = controller
    @write_accessor     = write_accessor
    @configuration_name = configuration_name
    
    # instance.write_accessor calls configuration.value=
    define_method( write_accessor ) { |value| controller.configuration( self, configuration_name ).value = value }
    
  end

end
