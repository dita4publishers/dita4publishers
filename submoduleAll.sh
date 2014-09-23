#!/bin/bash

# This script sets up ever D4P plugin as a submodule under the
# specified directory (e..g, DITA-OT/plugins
# usage: ./submoduleAll.sh <path/to/dir>

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
  echo " ! Please provide the location where you want the plugin submodules to be initialized."
  echo ""
  exit 1
fi

CLONEPATH=$1

# clone
git submodule add -f https://github.com/dita-community/org.dita-community.common.xslt.git ${CLONEPATH}/org.dita-community.common.xslt
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.common.xslt.git ${CLONEPATH}/org.dita4publishers.common.xslt
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.common.html.git ${CLONEPATH}/org.dita4publishers.common.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.common.mapdriven.git ${CLONEPATH}/org.dita4publishers.common.mapdriven
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.common.xslfo.git ${CLONEPATH}/org.dita4publishers.common.xslfo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.dita2indesign.git ${CLONEPATH}/org.dita4publishers.dita2indesign
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.doctypes.git ${CLONEPATH}/org.dita4publishers.doctypes
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.enumeration-d.fo.git ${CLONEPATH}/org.dita4publishers.enumeration-d.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.enumeration-d.html.git ${CLONEPATH}/org.dita4publishers.enumeration-d.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.epub.git ${CLONEPATH}/org.dita4publishers.epub
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.formatting-d.fo.git ${CLONEPATH}/org.dita4publishers.formatting-d.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.formatting-d.html.git ${CLONEPATH}/org.dita4publishers.formatting-d.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.graphviz.git ${CLONEPATH}/org.dita4publishers.graphviz
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.html2.git ${CLONEPATH}/org.dita4publishers.html2
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.html5.git ${CLONEPATH}/org.dita4publishers.html5
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.json.git ${CLONEPATH}/org.dita4publishers.json
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.kindle.git ${CLONEPATH}/org.dita4publishers.kindle
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.math.git ${CLONEPATH}/org.dita4publishers.math
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.math-d.html.git ${CLONEPATH}/org.dita4publishers.math-d.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.media-d.html.git ${CLONEPATH}/org.dita4publishers.media-d.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.pubContent-d.fo.git ${CLONEPATH}/org.dita4publishers.pubContent-d.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.pubmap.fo.git ${CLONEPATH}/org.dita4publishers.pubmap.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.pubmap.html.git ${CLONEPATH}/org.dita4publishers.pubmap.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.rss.git ${CLONEPATH}/org.dita4publishers.rss
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.ruby.fo.git ${CLONEPATH}/org.dita4publishers.ruby.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.ruby.html.git ${CLONEPATH}/org.dita4publishers.ruby.html
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.sample.epub_override.git ${CLONEPATH}/org.dita4publishers.sample.epub_override
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.word2dita.git ${CLONEPATH}/org.dita4publishers.word2dita
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.xmldomain.doctypes.git ${CLONEPATH}/org.dita4publishers.xmldomain.doctypes
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.xmldomain.fo.git ${CLONEPATH}/org.dita4publishers.xmldomain.fo
git submodule add -f https://github.com/dita4publishers/org.dita4publishers.xmldomain.html.git ${CLONEPATH}/org.dita4publishers.xmldomain.html
git submodule add -f https://github.com/dita4publishers/org.example.d4p.epub-custom.git ${CLONEPATH}/org.example.d4p.epub-custom
git submodule add -f https://github.com/dita4publishers/org.example.d4p.html2extensions.git ${CLONEPATH}/org.example.d4p.html2extensions
git submodule add -f https://github.com/dita4publishers/org.example.d4p.word2ditaextension.git ${CLONEPATH}/org.example.d4p.word2ditaextension

