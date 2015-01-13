#!/bin/bash
# HTML5 transform: 
cd $DITA_DIR
otdir=`pwd`
echo Running HTML5 transform on complex_map:
bin/dita -f d4p-html5 -i $DITA_DIR/test/dita/complex_map/complex_map.ditamap -o out/complex_map 

# EPUB transform:
echo Running EPUB transform on complex_map:
cd $otdir
bin/dita -f epub -i test/dita/complex_map/complex_map.ditamap -o out/complex_map 

# End of script