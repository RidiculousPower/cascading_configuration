
require 'module-cluster'

if $__cascading_configuration__spec__development
  require_relative '../setting/lib/cascading-configuration-setting.rb'
  require_relative '../settings-array/lib/cascading-configuration-array.rb'
  require_relative '../settings-array-unique/lib/cascading-configuration-array-unique.rb'
  require_relative '../settings-array-sorted/lib/cascading-configuration-array-sorted.rb'
  require_relative '../settings-array-sorted-unique/lib/cascading-configuration-array-sorted-unique.rb'
  require_relative '../settings-hash/lib/cascading-configuration-hash.rb'
else
  require 'cascading-configuration-setting'
  require 'cascading-configuration-array'
  require 'cascading-configuration-array-unique'
  require 'cascading-configuration-array-sorted'
  require 'cascading-configuration-array-sorted-unique'
  require 'cascading-configuration-hash'
end

module ::CascadingConfiguration
end

require_relative 'cascading-configuration/CascadingConfiguration.rb'
