
module CascadingConfiguration
  
  extend ModuleCluster::Define::Cluster
  
  include_also_includes( CascadingConfiguration::Setting, 
                         CascadingConfiguration::Array,
                         CascadingConfiguration::Hash )
  
  extend_also_extends( CascadingConfiguration::Setting,
                       CascadingConfiguration::Array,
                       CascadingConfiguration::Hash )
  
end
