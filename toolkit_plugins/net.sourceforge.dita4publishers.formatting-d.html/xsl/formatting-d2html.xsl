<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  >
  <!-- Formatting domain elements to XSL-FO -->
  
  <!-- Default width to use for tabs -->
  <xsl:param name="tabWidth" select="'1pc'" as="xs:string"/>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <br/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/tab ')]" priority="10"
    mode="#default getTitle">
    <span class="tab">&#x09;</span>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
</xsl:stylesheet>
