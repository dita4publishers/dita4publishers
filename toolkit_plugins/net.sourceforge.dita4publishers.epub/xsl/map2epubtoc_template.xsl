<!-- Convert a DITA map to an EPUB toc.ncx file. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
  >
  
  <xsl:include href="map2epubtocImpl.xsl"/>
  
  <dita:extension id="xsl.transtype-epub.toc" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>
  
</xsl:stylesheet>
