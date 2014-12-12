#!/bin/bash

# get DITA_OT
wget http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Stable%20Release/DITA%20Open%20Toolkit%201.8/DITA-OT1.8.5_full_easy_install_bin.tar.gz/download -O dita-ot.tar.gz --max-redirect=2

# untar
tar -xvf dita-ot.tar.gz

# install dp4 plugins
cp -r toolkit_plugins/* DITA-OT1.8.5/plugins/
cp -r test DITA-OT1.8.5/

# integrate
ant -f DITA-OT1.8.5/integrator.xml
