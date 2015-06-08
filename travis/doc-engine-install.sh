#!/bin/bash
set -e # exit with nonzero exit code if anything fails

SCRIPT_DIR=${PWD} 
echo "SCRIPT DIR =" $SCRIPT_DIR

travis env set ANT_OPTS -Xmx2048m
travis env set DITA_DIR DITA-OT1.8.5
travis env set CLASSPATH $DITA_DIR/lib/:$DITA_DIR/lib/dost.jar:$DITA_DIR/lib/commons-codec-1.4.jar:$DITA_DIR/lib/resolver.jar:lib/icu4j.jar:$DITA_DIR/lib/xercesImpl.jar:$DITA_DIR/lib/xml-apis.jar:$DITA_DIR/lib/saxon/saxon9.jar:$DITA_DIR/lib/saxon/saxon9-dom.jar
travis env set ANT_HOME $DITA_DIR/tools/ant PATH=$DITA_DIR/tools/ant/bin:$PATH
travis env set DITA_REPO http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Stable%20Release/DITA%20Open%20Toolkit%201.8/DITA-OT1.8.5_full_easy_install_bin.tar.gz/download

ls .
chmod +x $SCRIPT_DIR/travis/travis-before-install.sh
bash $SCRIPT_DIR/travis/travis-before-install.sh