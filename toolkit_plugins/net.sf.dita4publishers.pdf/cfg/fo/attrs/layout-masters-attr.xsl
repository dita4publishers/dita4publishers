<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
 <!-- Additional attribute sets for use by page masters and 
      page sequence masters.
   -->

  <xsl:attribute-set name="region-body.front-cover">
    <!-- By default, the cover body region fills the page so
         the cover graphic fills the page.
      -->
    <xsl:attribute name="margin-top" select="'0pt'"/>
    <xsl:attribute name="margin-bottom" select="'0pt'"/>
    <xsl:attribute name="margin-left" select="'0pt'"/>    
    <xsl:attribute name="margin-right" select="'0pt'"/>    
  </xsl:attribute-set>

    
</xsl:stylesheet>
