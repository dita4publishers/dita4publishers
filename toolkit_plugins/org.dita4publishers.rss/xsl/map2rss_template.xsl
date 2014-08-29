<!-- Convert a DITA map to an HTML5 data set. 

     Extensions to this transform can override or extend any of those modes.

-->
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:import href="map2rssImpl.xsl"/>

  <dita:extension id="xsl.transtype-rss" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>


</xsl:stylesheet>
