<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     FO generation templates for the enumerationDomain DITA domain.
     
     Copyright (c) 2010 W. DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >

  <xsl:template match="
    *[contains(@class, ' d4p_enum-d/d4pEnumerator ')]
    " priority="10">
     <fo:inline><xsl:apply-templates/></fo:inline>
  </xsl:template>

  <xsl:template match="
    *[contains(@class, ' d4p_simplenum-d/d4pSimpleEnumerator ')]
    " priority="10">
    <fo:inline><xsl:apply-templates/></fo:inline>
  </xsl:template>
  
  
</xsl:stylesheet>
