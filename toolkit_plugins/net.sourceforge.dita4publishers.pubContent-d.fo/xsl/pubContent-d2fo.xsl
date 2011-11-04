<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >
  <!-- publication content domain elements to XSL-FO -->

  <xsl:attribute-set name="d4p-epigram">
    <xsl:attribute name="font-style" select="'italic'"/>
    <xsl:attribute name="text-align" select="'right'"/>
    <xsl:attribute name="space-before" select="'12pt'"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="d4p-epigram-intro-leader">
    <xsl:attribute name="leader-length" select="'2pc'"/>
    <xsl:attribute name="leader-pattern" select="'rule'"/>
    <xsl:attribute name="baseline-shift" select="'4pt'"/>
  </xsl:attribute-set>  
  
  <xsl:template match="*[contains(@class, ' d4p-pubcontent-d/epigram ')]" priority="10">
    <fo:block xsl:use-attribute-sets="d4p-epigram">
      <fo:leader xsl:use-attribute-sets="d4p-epigram-intro-leader"/>
      <xsl:apply-templates/></fo:block>
  </xsl:template>  
</xsl:stylesheet>
