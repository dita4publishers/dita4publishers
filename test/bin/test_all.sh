#!/bin/bash
# HTML5 transform: 
echo Running HTML5 transform on complex_map:
$DITA_DIR/bin/dita -f d4p-html5 -i $DITA_DIR/test/dita/complex_map/complex_map.ditamap -o $DITA_DIR/out/complex_map -temp $DITA_DIR/temp/complex_map

# EPUB transform:
echo Running EPUB transform on complex_map:
$DITA_DIR/bin/dita -f epub -i $DITA_DIR/test/dita/complex_map/complex_map.ditamap -o $DITA_DIR/out/complex_map -temp $DITA_DIR/temp/complex_map

# End of script