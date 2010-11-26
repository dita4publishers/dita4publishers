<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     FO generation templates for the enumerationDomain DITA domain.
     
     Copyright (c) 2010 W. DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >

  <xsl:template match="
    *[contains(@class, ' d4p-ruby-d/ruby ')]
    " priority="10">
    <fo:inline-container text-indent="0mm" last-line-end-indent="0mm" alignment-baseline="central"
      >
      <xsl:apply-templates select="*[contains(@class, ' d4p-ruby-d/rt ')]"/>
      <xsl:apply-templates select="*[contains(@class, ' d4p-ruby-d/rb ')]"/>    
    </fo:inline-container>  
  </xsl:template>

  <xsl:template match="
    *[contains(@class, ' d4p-ruby-d/rb ')]
    " priority="10">
    <fo:block line-height="1em"><xsl:apply-templates/></fo:block>  
  </xsl:template>  

  <xsl:template match="
    *[contains(@class, ' d4p-ruby-d/rt ')] 
    " priority="10">
    <fo:block font-size="0.4em" text-align="center" line-height="1.2em" space-before="-1.5em" space-before.conditionality="retain"><xsl:apply-templates/></fo:block>  
  </xsl:template>  
  
  <xsl:template match="
    *[contains(@class, ' d4p-ruby-d/rp ')] 
    " priority="10">
    <!-- Suppress -->
  </xsl:template>  
</xsl:stylesheet>
