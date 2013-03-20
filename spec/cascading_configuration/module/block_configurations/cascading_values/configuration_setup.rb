# -*- encoding : utf-8 -*-

require_relative '../../configuration_setup.rb'

def setup_cascading_values_configuration_tests
  
  setup_configuration_tests
  
  let( :ccm_block ) { parent_configuration_block }
  
  let( :parent_configuration_block ) do
    ::Proc.new do |parent_string|
      child_string = parent_string.dup
      if /[0-9]/ =~ child_string[-1]
        number = child_string[-1]
        child_string[-1] = ( number.to_i + 1 ).to_s
      else
        child_string << '2' 
      end
      child_string
    end
  end
  let( :child_configuration_block ) do
    ::Proc.new do |parent_string|
      child_string = parent_string.dup
      if /[0-9]/ =~ child_string[-1]
        number = child_string[-1]
        child_string[-1] = ( number.to_i - 1 ).to_s
      else
        child_string << '9' 
      end
      child_string
    end
  end
  
end
