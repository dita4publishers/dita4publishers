<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
      exclude-result-prefixes="xs ditaarch"
      version="2.0">
  
  <!-- Splits out <chapter> topics to individual files-->
  
  <xsl:import href="common-identity-transform.xsl"/>
  
  <xsl:output 
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/pubmap"
    doctype-system="pubmap.dtd"
  />
  
  <xsl:output  name="chapter"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/chapter"
    doctype-system="chapter.dtd"
  />
  
  <xsl:template match="/">
    <pubbody>
      <xsl:apply-templates/>
    </pubbody>
  </xsl:template>

  <xsl:template match="chapter">
    <xsl:variable name="targetUri" as="xs:string" 
      select="concat('chapters/chapter_', count(preceding-sibling::chapter) + 1, '.xml')"
    />
    <chapter href="{$targetUri}"/>
    <xsl:result-document href="{$targetUri}" format="chapter">
      <xsl:copy>
        <xsl:attribute name="id" select="'chapterid'"/>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:result-document>
  </xsl:template>  
  
  <xsl:template match="@align">
    <xsl:attribute name="outputclass" select="."/>
  </xsl:template>
  
  <xsl:template match="blockquote">
    <lq>
      <xsl:apply-templates/>
    </lq>
  </xsl:template>
  
  
</xsl:stylesheet>
