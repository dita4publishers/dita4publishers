<!-- Convert a DITA map to a GraphViz DOT data set from which
		various graphical renderings can be generated. 

     Extensions to this transform can override or extend any of those modes.

-->
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="map2graphvizImpl.xsl"/>

  <dita:extension id="xsl.transtype-graphviz" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>

</xsl:stylesheet>
