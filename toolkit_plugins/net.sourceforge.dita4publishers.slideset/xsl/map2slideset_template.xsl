<!-- Convert a DITA map to a SimpleSlideSet document from which
		various slide formats can be generated (e.g., PPTX).

     Extensions to this transform can override or extend any of those modes.

-->
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="map2slidesetImpl.xsl"/>

  <dita:extension id="xsl.transtype-slideset" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>

</xsl:stylesheet>
