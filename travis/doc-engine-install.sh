#!/bin/bash
set -e # exit with nonzero exit code if anything fails

SCRIPT_DIR=${PWD##*/} 

export ANT_OPTS=-Xmx2048m
export DITA_DIR=DITA-OT1.8.5
export CLASSPATH=$DITA_DIR/lib/:$DITA_DIR/lib/dost.jar:$DITA_DIR/lib/commons-codec-1.4.jar:$DITA_DIR/lib/resolver.jar:lib/icu4j.jar:$DITA_DIR/lib/xercesImpl.jar:$DITA_DIR/lib/xml-apis.jar:$DITA_DIR/lib/saxon/saxon9.jar:$DITA_DIR/lib/saxon/saxon9-dom.jar ANT_HOME=$DITA_DIR/tools/ant PATH=$DITA_DIR/tools/ant/bin:$PATH
export DITA_REPO=http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Stable%20Release/DITA%20Open%20Toolkit%201.8/DITA-OT1.8.5_full_easy_install_bin.tar.gz/download

bash $SCRIPT_DIR/travis-before-install.sh