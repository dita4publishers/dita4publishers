<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="df xs"
  version="2.0">
  
  <xsl:template match="*[df:class(., 'd4p-math-d/d4p_MathML')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="m:math">
    <xsl:copy>
      <xsl:apply-templates mode="copy-math" select="@*,node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="copy-math" match="m:annotation" priority="10">
    <!-- Suppress in preview -->
  </xsl:template>
  
  <xsl:template mode="copy-math" match="m:*">
    <xsl:copy>
      <xsl:apply-templates mode="copy-math" select="@*,node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="copy-math" match="@*">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="copy-math" match="text()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  
  
  
</xsl:stylesheet>