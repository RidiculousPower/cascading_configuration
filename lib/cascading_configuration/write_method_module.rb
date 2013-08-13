# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::Controller::WriteMethodModule < ::Module

  ################
  #  initialize  #
  ################

  def initialize( write_accessor, configuration_name )
    
    # instance.write_accessor calls configuration.value=
    define_method( write_accessor ) do |value|
      ::CascadingConfiguration.configuration( self, configuration_name ).value = value
    end
    
  end

end
