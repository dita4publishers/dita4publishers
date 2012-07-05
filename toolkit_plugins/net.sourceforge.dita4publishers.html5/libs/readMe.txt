*******************************************
This information is intented to developpers
*******************************************

Directory Structure
*******************

* css -> compressed css
* js -> compressed js
* libs -> all js and css libraries

* libs/cowboy-jquery-bbq-8e0064b

  jQuery BBQ leverages the HTML5 hashchange event to allow simple, yet powerful bookmarkable #hash history.

  http://benalman.com/projects/jquery-bbq-plugin/

* libs/jQuery

  http://jquery.com/

* libs/jquery-ui

  http://jqueryui.com/

* libs/html5

	Current library for the dita4publishers.html5 plugin

* libs/modernizr

  Modernizr is an open-source JavaScript library that helps you build the next generation of HTML5 and CSS3-powered websites

	http://modernizr.com/

* libs/nathansmith-960-Grid-System-b0c5b98

	a 960 css framework (grid)



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