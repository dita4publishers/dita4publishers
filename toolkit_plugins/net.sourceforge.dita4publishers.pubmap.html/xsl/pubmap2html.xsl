<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the pubmap DITA domain.
     
     Copyright (c) 2009 DITA For Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="*[contains(@class, ' chapter/chapter ')]/*[contains(@class, ' topic/title ')]">
      <xsl:param name="headinglevel">
        <xsl:choose>
          <xsl:when test="count(ancestor::*[contains(@class,' topic/topic ')]) > 6">6</xsl:when>
          <xsl:otherwise><xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])"/></xsl:otherwise>
        </xsl:choose>
      </xsl:param>
      <xsl:element name="h{$headinglevel}">
        <xsl:attribute name="class">chaptertitle<xsl:value-of select="$headinglevel"/></xsl:attribute>
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class">chaptertitle<xsl:value-of select="$headinglevel"/></xsl:with-param>
        </xsl:call-template>
        <xsl:text>Chapter </xsl:text><!-- FIXME: Get from static text database -->
        <xsl:value-of select="'n'"/>
        <xsl:text>.&#xa0;</xsl:text>
        <xsl:apply-templates/>
      </xsl:element>
      <xsl:text>&#x0a;</xsl:text>      
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]">
    <xsl:message> + [DEBUG]  d4p-formatting-d/art template.</xsl:message>
    <xsl:apply-templates select="*[contains(@class, ' topic/image ')]"></xsl:apply-templates>
  </xsl:template>
  
</xsl:stylesheet>
