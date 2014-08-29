<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >
  <!-- XML Domain elements to FO -->
  
  <xsl:template match="*[contains(@class, ' xml-d/xmlelem ')]" priority="10">
    <fo:inline font-size="90%" font-family="Monospaced">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' xml-d/xmlatt ')]" priority="10">
    <fo:inline font-size="90%" font-family="Monospaced">
      <xsl:text>@</xsl:text>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' xml-d/textent ')]" priority="10">
    <fo:inline font-size="90%" font-family="Monospaced">
      <xsl:text>&amp;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>;</xsl:text>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' xml-d/parment ')]" priority="10">
    <fo:inline font-size="90%" font-family="Monospaced">
      <xsl:text>%</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>;</xsl:text>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' xml-d/numcharref ')]" priority="10">
    <fo:inline font-size="90%" font-family="Monospaced">
      <xsl:text>&amp;#</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>;</xsl:text>
    </fo:inline>
  </xsl:template>
  
</xsl:stylesheet>
