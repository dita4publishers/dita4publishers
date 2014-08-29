<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the enumerationDomain DITA domain.
     
     Copyright (c) 2010 W. DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="
    *[contains(@class, ' d4p_enum-d/d4pEnumerator ')]
    " priority="10">
     <span class="d4pEnumerator"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="
    *[contains(@class, ' d4p_simplenum-d/d4pSimpleEnumerator ')]
    " priority="10">
    <span class="d4pSimpleEnumerator"><xsl:apply-templates/></span>
  </xsl:template>
  
  
</xsl:stylesheet>
