#!/bin/bash

# get DITA_OT
wget $DITA_REPO -O dita-ot.tar.gz --max-redirect=2

# untar
tar -xvf dita-ot.tar.gz

echo ls .:
ls .

# install dp4 plugins (note, this runs the integrator script)
ant deploy-toolkit-plugins -Ddita-ot-dir=$DITA_DIR

# install tests
cp -r test $DITA_DIR/

