<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <!-- ============================================
       Transform to generate DITA XML from USFX 
       bible documents.
       
       ============================================ -->
  
  <xsl:template match="/">
    <map>
      <title>Bible <xsl:value-of select=""></xsl:value-of></title>
    </map>
  </xsl:template>
  
  <!-- ======================
       Mode: map-title
       ====================== -->
  
  <xsl:template mode="map-title" match=""></xsl:template>
  
  <xsl:template mode="map-title" priority="-1" match="*">
    <!-- Suppress -->
  </xsl:template>
  
</xsl:stylesheet>