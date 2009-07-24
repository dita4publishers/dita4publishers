<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">
  
  <xsl:variable name="debugBoolean" select="true()" as="xs:boolean"/>
  
  <xsl:include href="resolve-map.xsl"/>
  
  <xsl:template match="/">
    <xsl:variable name="resolvedMap" as="element()">
      <xsl:apply-templates mode="resolve-map">
        <xsl:with-param name="parentHeadLevel" select="0" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:sequence select="$resolvedMap"/>
  </xsl:template>

</xsl:stylesheet>
