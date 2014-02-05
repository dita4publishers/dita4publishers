<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  
  exclude-result-prefixes="xs df"
  version="2.0">
  
  <!-- Pub Title mode: -->

  <xsl:template mode="pubtitle" match="@title">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/title')]" mode="pubtitle">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'bookmap/booktitle')]" mode="pubtitle" priority="10">
    <xsl:apply-templates mode="#current" select="*[df:class(., 'bookmap/mainbooktitle')]"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmap-d/pubtitle')]" mode="pubtitle" priority="10">
    <xsl:apply-templates mode="#current" select="*[df:class(., 'pubmap-d/mainpubtitle')]"/>
  </xsl:template>
  
  <xsl:template mode="pubtitle" match="*" priority="-1">
    <xsl:message> + [WARNING] mode pubtitle: unhandled element <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="pubtitle" match="*[df:class(., 'topic/ph')] | 
    *[df:class(., 'topic/term')] | 
    *[df:class(., 'topic/keyword')] | 
    *[df:class(., 'topic/text')] ">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  
</xsl:stylesheet>
