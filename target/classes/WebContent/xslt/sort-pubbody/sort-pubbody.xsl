<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="xs df"  
  version="2.0">
  <xsl:import href="../lib/dita-support-lib.xsl"/>
  
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Feb 5, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output
    doctype-public="urn:pubid:dita4publishers.sourceforge.net:doctypes:dita:dtd:pubmap" 
    doctype-system="pubmap.dtd"
   />
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@class | @domains"/>
  
  <xsl:template match="*[df:class(.,'pubmap-d/pubbody')]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each-group select="*[df:class(., 'map/topicref')]"
        group-by="lower-case(substring(df:getNavtitleForTopicref(.), 1,1))"
        >
        <xsl:sort select="lower-case(substring(df:getNavtitleForTopicref(current-group()[1]), 1,1))"/>
        <topichead navtitle="{upper-case(substring(df:getNavtitleForTopicref(current-group()[1]), 1,1))}">
          <xsl:apply-templates select="current-group()">
            <xsl:sort select="lower-case(df:getNavtitleForTopicref(.))"/>
          </xsl:apply-templates>
        </topichead>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
    
    <xsl:template match="@* | text()">
      <xsl:sequence select="."/>
    </xsl:template>
  
    
</xsl:stylesheet>
