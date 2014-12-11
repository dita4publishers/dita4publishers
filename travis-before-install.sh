#!/bin/bash
wget http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Stable%20Release/DITA%20Open%20Toolkit%201.8/DITA-OT1.8.5_full_easy_install_bin.tar.gz/download -O dita-ot.tar.gz --max-redirect=2
tar -xvf dita-ot.tar.gz
cp -r toolkit_plugins/* DITA-OT1.8.5/plugins/
ant -f DITA-OT1.8.5/integrator.xml
cd DITA-OT1.8.5
travis env set DITA_DIR DITA-OT1.8.5
travis env set ANT_OPTS="-Xmx512m $ANT_OPTS -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
travis env set CLASSPATH DITA-OT1.8.5/lib/dost.jar:DITA-OT1.8.5/lib/commons-codec-1.4.jar:DITA-OT1.8.5/lib/resolver.jar:lib/icu4j.jar:DITA-OT1.8.5/lib/xercesImpl.jar:DITA-OT1.8.5/lib/xml-apis.jar:DITA-OT1.8.5/lib/saxon/saxon9.jar:DITA-OT1.8.5/lib/saxon/saxon9-dom.jar
