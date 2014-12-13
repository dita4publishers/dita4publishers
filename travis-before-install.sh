#!/bin/bash

# get DITA_OT
wget $DITA_REPO -O dita-ot.tar.gz --max-redirect=2

# untar
tar -xvf dita-ot.tar.gz

# install dp4 plugins
cp -r toolkit_plugins/* $DITA_DIR/plugins/

# install tests
cp -r test $DITA_DIR/

# integrate
ant -f $DITA_DIR/integrator.xml
