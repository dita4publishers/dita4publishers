#!/bin/bash
# 
# Batch file to generate HTML from a DITA map
# 
# NOTE: This script is intended to be run from the directory containing the map to be processed 
# 


if [ ! "$1" ]; then
    echo
    echo "Usage:"
    echo
    echo "    $0 {map filename} [debug]"
    echo
    exit 127;
fi

echo "2=$2"

if [ ! "$2" ]; then
  echo "Setting debug"
  export DEBUG="/debug"
fi

echo "DEBUG: ${DEBUG}"
if [ ! "$DITA_HOME" ]; then
   echo "You must set the DITA_HOME environment variable to point to the install directory for the DITA Open Toolkit";
   echo "e.g., set DITA_HOME=/Applications/DITA-OT4.1.1";
   exit 127;
fi

if [ ! -d $DITA_HOME ]; then
    echo "DITA_HOME directory '$DITA_HOME' does not exist. Cannot continue.";
    exit 127;
fi

if [ ! "$DITA_DIR" ]; then
# In case some downstream process expects this environment variable to be set:
    export DITA_DIR=$DITA_HOME
    
    export ANT_OPTS="-Xmx512m $ANT_OPTS"
    export ANT_HOME=$DITA_HOME/tools/ant
    export PATH=$DITA_HOME/tools/ant/bin:$PATH
# NOTE: Omitting XALAN from the classpath to force use of saxon.
# NOTE: Omitting appending of any existing CLASSPATH value to keep things predictable.
# NOTE: Using Saxon 9 to get XSLT 2 support
    export CLASSPATH=$DITA_HOME/lib:$DITA_HOME/lib/dost.jar:$DITA_HOME/lib/saxon9.jar:$DITA_HOME/lib/saxon9-dom.jar:$DITA_HOME/lib/resolver.jar:$DITA_HOME/lib/xercersImpl.jar:$DITA_HOME/lib/xml-apis.jar:$DITA_HOME/lib/icu4j.jar
fi

if [ ! -d $DITA_HOME/demo/tocjs ]; then
    echo " - WARNING: The TOCJS plugin does not seem to be installed. No TOC will generated.";
fi

export DOC_HOME="`pwd`"

export OUTDIR=${DOC_HOME}/build/html
export MODULE_HOME=/Users/ekimber/workspace/dita2indesign
export XSLTDIR=${MODULE_HOME}xslt/


echo ""
echo "+ Output will be in directory '$OUTDIR'..."
echo ""

# For 1.4:
export OUTERCONTROL=/outercontrol:quiet

# Generate the HTML:
#
export cmd="java -jar $DITA_HOME/lib/dost.jar $OUTERCONTROL /i:$1 /outdir:$OUTDIR /tempdir:${DOC_HOME}/temp /transtype:xhtml /ditadir:$DITA_HOME /copycss:yes /css:${MODULE_HOME}/html/css/branding/d2id.css /csspath:css /ftr:${DOC_HOME}/html/running-footer.html /hdr:${DOC_HOME}/html/running-header.html /debug"
echo "cmd=$cmd";
eval $cmd

# Generate TOCJS TOC
# java -jar $DITA_HOME/lib/dost.jar $OUTERCONTROL /i:$1 /outdir:$OUTDIR /transtype:tocjs /ditadir:$DITA_HOME /tempdir:${DOC_HOME}/temp

#
# Copy static HTML stuff to the output:
#
#cp -r ${MODULE_HOME}/html/* ${OUTDIR}
#cp -r ${DOC_HOME}/html/* ${OUTDIR}

#mv ${DOC_HOME}/'${output.file}' ${OUTDIR}/toctree.js
exit 0

#
# End of script
#