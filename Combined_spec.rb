$__cascading_configuration__spec__development = true

specs = [

  [
    'setting/spec/',
    'settings-array/spec/',
    'settings-array-unique/spec/',
    'settings-array-sorted/spec/',
    'settings-array-sorted-unique/spec/',
    'settings-hash/spec/',
    'variable/spec/'
  ]

]

module CascadingConfiguration
end

specs.each do |this_spec|

  pid = fork do

    describe CascadingConfiguration do

      RSpec::Core::Runner.run( this_spec, $stderr, $stdout )
  
    end
  
  end
  
  Process.wait( pid )
  
end
