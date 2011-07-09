
module CascadingConfiguration
	module ClassInstance
		module Accessor
		end
	end
	module ObjectInstance
	end
	module ConfigurationVariable
		module ClassInstance
		end
		module ObjectInstance
		end
	end
	module CascadingComposite
	end
	module CascadingCompositeArray
	end
	module ConfigurationSet
	end
	module ConfigurationArray
	end
	module ConfigurationSettingsArray
	end
	module CascadingCompositeHash
	end
	module ConfigurationHash
	end
	module ConfigurationSettingsHash
	end
	module ConfigurationSetting
	end
end

require_relative 'cascading-configuration/CascadingConfiguration.rb'

require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationVariable.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationVariable/ClassInstance.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationVariable/ObjectInstance.rb'

require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSettingsArray.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSettingsArray/ClassInstance.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSettingsHash.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSettingsHash/ClassInstance.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSetting.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationSetting/ClassInstance.rb'

require_relative 'cascading-configuration/CascadingConfiguration/CascadingComposite.rb'
require_relative 'cascading-configuration/CascadingConfiguration/_private_/CascadingComposite.rb'
require_relative 'cascading-configuration/CascadingConfiguration/CascadingCompositeArray.rb'
require_relative 'cascading-configuration/CascadingConfiguration/CascadingCompositeHash.rb'
require_relative 'cascading-configuration/CascadingConfiguration/_private_/CascadingCompositeArray.rb'
require_relative 'cascading-configuration/CascadingConfiguration/_private_/CascadingCompositeHash.rb'

require_relative 'cascading-configuration/CascadingConfiguration/_private_/ConfigurationSet.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationArray.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ConfigurationHash.rb'

require_relative 'cascading-configuration/CascadingConfiguration/ObjectInstance.rb'

require_relative 'cascading-configuration/CascadingConfiguration/ClassInstance.rb'
require_relative 'cascading-configuration/CascadingConfiguration/_private_/ClassInstance.rb'
require_relative 'cascading-configuration/CascadingConfiguration/ClassInstance/Accessors.rb'
