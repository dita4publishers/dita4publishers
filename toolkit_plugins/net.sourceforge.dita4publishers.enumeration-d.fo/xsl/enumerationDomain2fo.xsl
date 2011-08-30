<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     FO generation templates for the enumerationDomain DITA domain.
     
     Copyright (c) 2010, 2011 DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >
  
  <xsl:param name="d4p_showSimpleEnumerations" select="'true'"/>
  <xsl:variable name="d4p_showSimpleEnumerationsBoolean" as="xs:boolean"
    select="
    if (lower-case($d4p_showSimpleEnumerations) = 'false') 
    then false() 
    else true()"
  />

  <xsl:template match="
    *[contains(@class, ' d4p_enum-d/d4pEnumerator ')]
    " priority="10">
    <xsl:if test="$d4p_showSimpleEnumerationsBoolean">
     <fo:inline><xsl:apply-templates/></fo:inline>
    </xsl:if>
  </xsl:template>

  <xsl:template match="
    *[contains(@class, ' d4p_simplenum-d/d4pSimpleEnumerator ')]
    " priority="10">
    <xsl:if test="$d4p_showSimpleEnumerationsBoolean">
    	<fo:inline><xsl:apply-templates/></fo:inline>
    </xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>
