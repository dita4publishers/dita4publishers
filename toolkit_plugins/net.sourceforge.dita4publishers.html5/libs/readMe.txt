*******************************************
This information is intented to developpers
*******************************************

How to build the the css and javascripts
****************************************
The build.xml file contains information to assemble all the javascripts and css of the differents library into :

- css/style.css: concatenated and compressed css
- js/script.js: concatenated and compressed javascripts


1. Download and unpack in the libs directory
   a version of Yahoo YUI compressor

   http://yuilibrary.com/download/yuicompressor/


2. In the ant.properties files, change the ant properties for the
   path of the jar file and the libraries if necessary

   yui.path = yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar
   lib.dir = yuicompressor-2.4.7/lib


3. run the build

	ant -f build.xml


All files should be aggregated and compressed