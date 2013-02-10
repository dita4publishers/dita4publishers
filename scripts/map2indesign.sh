#!/bin/sh

progname=`basename "$0"`

# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
  PRG="$link"
  else
  PRG=`dirname "$PRG"`"/$link"
  fi
done

PROJECT_HOME=`dirname "$PRG"`/..

PROJECT_HOME=`cd "$PROJECT_HOME" && pwd`
LIB=${PROJECT_HOME}/lib/

export DITAOT_HOME=/Applications/oxygen_10.2/frameworks/dita/DITA-OT

CP=${PROJECT_HOME}/build:${LIB}commons-logging.jar:${LIB}log4j.jar:${LIB}saxon9.jar:${LIB}saxon9-dom.jar:${LIB}saxon9-s9api.jar:\
${LIB}saxon9-xpath.jar:${LIB}commons-io.jar:${LIB}rsi-inx-util.jar:${LIB}xercesImpl.jar:${LIB}xml-apis.jar:${LIB}xml-resolver.jar:${LIB}commons-cli.jar



java -cp ${CP} org.dita2indesign.cmdline.Map2InDesign -i $1 -o $2

# End of script