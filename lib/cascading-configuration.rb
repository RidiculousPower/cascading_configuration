
require 'gem-loaded'

if Gem.loaded?( 'cascading-configuration' )
	require 'cascading-configuration-setting'
	require 'cascading-configuration-array'
	require 'cascading-configuration-hash'
else
	require_relative '../setting/lib/cascading-configuration-setting.rb'
	require_relative '../settings-array/lib/cascading-configuration-array.rb'
	require_relative '../settings-hash/lib/cascading-configuration-hash.rb'
end

module CascadingConfiguration
end

require_relative 'cascading-configuration/CascadingConfiguration.rb'
