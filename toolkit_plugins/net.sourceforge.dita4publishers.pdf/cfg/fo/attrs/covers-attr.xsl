<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
 <!-- Attribute sets for controlling front and back covers.
   -->

  <xsl:attribute-set name="front-cover-graphic">
    <!-- By default, the cover body region fills the page so
         the cover graphic fills the page.
      -->
    <xsl:attribute name="content-height" select="'scale-to-fit'"/>
    <xsl:attribute name="scaling" select="'uniform'"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="back-cover-graphic">
    <!-- By default, the graphic is 1/2 width, which
         should make a squarish graphic occupy
         about a 1/4 of the page area.
      -->
    <xsl:attribute name="content-width" select="'50%'"/>
    <xsl:attribute name="scaling" select="'uniform'"/>
  </xsl:attribute-set>

    
</xsl:stylesheet>
