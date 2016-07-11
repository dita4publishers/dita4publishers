#!/bin/bash -e
# ref -e https://groups.google.com/forum/#!topic/travis-ci/JtC4WiCMA0w
# The command to run is defined in the env in the .travis.yml configuration
# so that we can either use ant or use the DIT 2.x dita command
echo Calling command $CMD...
$CMD 