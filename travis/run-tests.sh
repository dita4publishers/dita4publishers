#!/bin/bash
# The command to run is defined in the env in the .travis.yml configuration
# so that we can either use ant or use the DIT 2.x dita command
echo ls $DITA_DIR
ls $DITA_DIR
ls $DITA_DIR/test
ls $DITA_DIR/test/bin
tree $DITA_DIR
echo Calling command $CMD...
$CMD
echo Done
