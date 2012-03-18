#!/bin/bash

ROOTDIR=$PWD
GEMS=$ROOTDIR/gems/

CASCADING_CONFIGURATION=$ROOTDIR

CASCADING_CONFIGURATION_SETTING=$CASCADING_CONFIGURATION/setting
CASCADING_CONFIGURATION_ARRAY=$CASCADING_CONFIGURATION/settings-array
CASCADING_CONFIGURATION_ARRAY_UNIQUE=$CASCADING_CONFIGURATION/settings-array-unique
CASCADING_CONFIGURATION_ARRAY_SORTED=$CASCADING_CONFIGURATION/settings-array-sorted
CASCADING_CONFIGURATION_ARRAY_SORTED_UNIQUE=$CASCADING_CONFIGURATION/settings-array-sorted-unique
CASCADING_CONFIGURATION_HASH=$CASCADING_CONFIGURATION/settings-hash
CASCADING_CONFIGURATION_ANCESTORS=$CASCADING_CONFIGURATION/ancestors
CASCADING_CONFIGURATION_METHODS=$CASCADING_CONFIGURATION/methods
CASCADING_CONFIGURATION_INHERITANCE=$CASCADING_CONFIGURATION/inheritance
CASCADING_CONFIGURATION_VARIABLE=$CASCADING_CONFIGURATION/variable

gem build cascading-configuration.gemspec
mv cascading-configuration*.gem $GEMS/

cd $CASCADING_CONFIGURATION_SETTING
gem build cascading-configuration-setting.gemspec
mv cascading-configuration-setting*.gem $GEMS/

cd $CASCADING_CONFIGURATION_ARRAY
gem build cascading-configuration-array.gemspec
mv cascading-configuration-array*.gem $GEMS/

cd $CASCADING_CONFIGURATION_ARRAY_UNIQUE
gem build cascading-configuration-array-unique.gemspec
mv cascading-configuration-array-unique*.gem $GEMS/

cd $CASCADING_CONFIGURATION_ARRAY_SORTED
gem build cascading-configuration-array-sorted.gemspec
mv cascading-configuration-array-sorted*.gem $GEMS/

cd $CASCADING_CONFIGURATION_ARRAY_SORTED_UNIQUE
gem build cascading-configuration-array-sorted-unique.gemspec
mv cascading-configuration-array-sorted-unique*.gem $GEMS/

cd $CASCADING_CONFIGURATION_HASH
gem build cascading-configuration-hash.gemspec
mv cascading-configuration-hash*.gem $GEMS/

cd $CASCADING_CONFIGURATION_ANCESTORS
gem build cascading-configuration-ancestors.gemspec
mv cascading-configuration-ancestors*.gem $GEMS/

cd $CASCADING_CONFIGURATION_METHODS
gem build cascading-configuration-methods.gemspec
mv cascading-configuration-methods*.gem $GEMS/

cd $CASCADING_CONFIGURATION_INHERITANCE
gem build cascading-configuration-inheritance.gemspec
mv cascading-configuration-inheritance*.gem $GEMS/

cd $CASCADING_CONFIGURATION_VARIABLE
gem build cascading-configuration-variable.gemspec
mv cascading-configuration-variable*.gem $GEMS/

cd $ROOTDIR
