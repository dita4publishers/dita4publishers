<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  >
  <!-- Formatting domain elements to XSL-FO -->
  
  <!-- Default width to use for tabs -->
  <xsl:param name="tabWidth" select="'1pc'" as="xs:string"/>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <xsl:message> + [DEBUG] handling d4p-formatting-d/br </xsl:message>
    <fo:block>&#xa0;</fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/tab ')]" priority="10"
    mode="#default getTitle">
    <fo:leader leader-length="{tabWidth}" leader-pattern="space"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' d4p-formatting-d/b-i ')]">
    <fo:inline font-weight="bold" font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <!-- FIXME: Implement some sort of support for the other formatting-d elements. -->
</xsl:stylesheet>
