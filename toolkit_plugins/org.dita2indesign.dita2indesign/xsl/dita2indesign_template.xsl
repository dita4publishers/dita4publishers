<!-- Convert a DITA map or topic to one or more InCopy (InDesign) article (.incx) 
     files.  

     Extensions to this transform can override or extend any of those modes.


-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <dita:extension id="xsl.transtype-indesign" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>

  <xsl:include href="dita2indesignImpl.xsl"/>
  <xsl:include href="elem2styleMapper.xsl"/>

</xsl:stylesheet>
