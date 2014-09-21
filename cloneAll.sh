#!/bin/bash

# This script clone every repositories into the director of your choice
# usage: ./cloneAll.sh <path/to/dir>

# find right location
realpath() {

  case $1 in
    /*) echo "$1" ;;
    *) echo "$PWD/${1#./}" ;;
  esac
}

CURRENT_DIR="$(dirname "$(realpath "$0")")"

# check paramaters
if  [ $# -ne 1 ]
then
  echo ""
  echo " ! Please provide the location where you want the plugins to be cloned."
  echo ""
  exit 1
fi

CLONEPATH=$1
cd $CLONEPATH

# clone
git clone git@github.com:dita-community/org.dita-community.common.xslt.git
git clone git@github.com:dita4publishers/org.dita4publishers.common.xslt.git
git clone git@github.com:dita4publishers/org.dita4publishers.common.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.common.mapdriven.git
git clone git@github.com:dita4publishers/org.dita4publishers.common.xslfo.git
git clone git@github.com:dita4publishers/org.dita4publishers.dita2indesign.git
git clone git@github.com:dita4publishers/org.dita4publishers.doctypes.git
git clone git@github.com:dita4publishers/org.dita4publishers.enumeration-d.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.enumeration-d.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.epub.git
git clone git@github.com:dita4publishers/org.dita4publishers.formatting-d.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.formatting-d.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.graphviz.git
git clone git@github.com:dita4publishers/org.dita4publishers.html2.git
git clone git@github.com:dita4publishers/org.dita4publishers.html5.git
git clone git@github.com:dita4publishers/org.dita4publishers.json.git
git clone git@github.com:dita4publishers/org.dita4publishers.kindle.git
git clone git@github.com:dita4publishers/org.dita4publishers.math.git
git clone git@github.com:dita4publishers/org.dita4publishers.math-d.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.media-d.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.pubContent-d.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.pubmap.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.pubmap.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.rss.git
git clone git@github.com:dita4publishers/org.dita4publishers.ruby.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.ruby.html.git
git clone git@github.com:dita4publishers/org.dita4publishers.sample.epub_override.git
git clone git@github.com:dita4publishers/org.dita4publishers.word2dita.git
git clone git@github.com:dita4publishers/org.dita4publishers.xmldomain.doctypes.git
git clone git@github.com:dita4publishers/org.dita4publishers.xmldomain.fo.git
git clone git@github.com:dita4publishers/org.dita4publishers.xmldomain.html.git
git clone git@github.com:dita4publishers/org.example.d4p.epub-custom.git
git clone git@github.com:dita4publishers/org.example.d4p.html2extensions.git
git clone git@github.com:dita4publishers/org.example.d4p.word2ditaextension.git

# come back
cd $CURRENT_DIR
