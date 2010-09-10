<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:d="http://dita2indesign.org/dita/functions"
    xmlns:f="http://reallysi.com/xslt/util/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="d f xs"
  >
  
<!--=====================================================================
    DITA2InDesign: Map 2 Importable XML for InDesign
    
    Copyright (c) 2008 DITA2InDesign Project
    
    Utility transform to process a DITA map and report all the references
    it within it as a debugging aid.
      
    =====================================================================-->
  
<xsl:import href="../lib/dita-support-lib.xsl"/>
  
<xsl:output method="text"/>  
  
<xsl:param name="debug" select="'false'" as="xs:string"/>
  
<xsl:variable name="debugBoolean" as="xs:boolean" select="if ($debug = 'true' or $debug = 'yes') then true() else false()"/>
  
<xsl:template match="/">
  <xsl:variable name="origInputUri" select="string(base-uri(.))" as="xs:string"/>
  <!-- NOTE: here the container elements will not be directly put into InDesign
             page items so we don't have to worry about indenting and white space.
  -->
  <xsl:variable name="resolvedMap" as="element()">
    <xsl:message> + Info: Resolving map...</xsl:message>
    <xsl:apply-templates select="*[d:class(., 'map/map')]" mode="resolve-maprefs"/>
    <xsl:message> + Info: Map resolved</xsl:message>
  </xsl:variable>
  <!--
  <xsl:result-document href="file:///c:/temp/resolvedMap.xml" method="xml">
    <xsl:sequence select="$resolvedMap"/>
  </xsl:result-document>
  -->
  <xsl:message> + INFO: Applying templates to resolved map to generate the report:</xsl:message>
  <xsl:apply-templates select="$resolvedMap" mode="generate-report">
    <xsl:with-param name="origInputUri" select="$origInputUri" tunnel="yes" as="xs:string"/>
  </xsl:apply-templates>
  <xsl:message> + INFO: Report generated</xsl:message>
</xsl:template>
  
<xsl:template match="/" mode="generate-report" priority="10">
  <xsl:message>* in "/" mode=generate-report</xsl:message>
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="*[d:class(.,'map/map')]" mode="generate-report" priority="10">
  <xsl:param name="origInputUri" tunnel="yes" as="xs:string"/>
  <xsl:text>Map report for map: </xsl:text>
  <xsl:sequence select="$origInputUri"/><xsl:text>&#x0a;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="*" priority="-1">
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="*[d:class(., 'map/topicref') and (not(@href) or (@href = ''))]">
  
  <xsl:message>+ <xsl:sequence select="f:indentTopicRef(.)"/>Topic head: "<xsl:value-of select="@navtitle"/>"</xsl:message>
  <xsl:text>&#x0a;+ </xsl:text>
  <xsl:sequence select="f:indentTopicRef(.)"/>
  <xsl:text>Topic head: "</xsl:text>
  <xsl:value-of select="@navtitle"/>
  <xsl:text>"</xsl:text>
  <xsl:apply-templates/>
</xsl:template>  
  
<xsl:template match="*[d:class(., 'map/topicref') and (@href != '')]">
  <xsl:variable name="targetUri" select="@href" as="xs:string"/>
  <xsl:variable name="docAvail" select="doc-available(resolve-uri($targetUri, base-uri(root(.))))"/>
  <xsl:variable name="resolvedIndicator" as="xs:string" select="if ($docAvail) then '+' else '-'"/>
  <xsl:variable name="navtitle" select="d:getNavtitleForTopicref(.)"/>
  
  <xsl:message>+ <xsl:sequence select="f:indentTopicRef(.)"/>Topic ref: "<xsl:value-of select="@navtitle"/>"</xsl:message>
  <xsl:text>&#x0a;+ </xsl:text>
  <xsl:sequence select="f:indentTopicRef(.)"/>
  <xsl:sequence select="$resolvedIndicator"/>
  <xsl:text> Topic ref: target="</xsl:text><xsl:sequence select="$targetUri"/><xsl:text>"</xsl:text>
  <xsl:text>, navtitle: "</xsl:text><xsl:sequence select="$navtitle"/><xsl:text>"</xsl:text>
  <xsl:apply-templates/>
</xsl:template>  
  
<!-- ===================================
     MODE resolve-maprefs 
     =================================== -->
  
<xsl:template match="*[d:class(., 'map/map')]" mode="resolve-maprefs">
  <xsl:call-template name="copy-element"/>
</xsl:template>  
  
  
<xsl:template match="*[d:class(., 'map/topicref') and @href != '' and @format = 'ditamap']" mode="resolve-maprefs">
  <xsl:call-template name="resolve-mapref"/>
</xsl:template>  

<xsl:function name="f:indentTopicRef" as="xs:string">
  <xsl:param name="context" as="element()"/>
  <xsl:variable name="ancestorCount" select="count($context/ancestor-or-self::*[d:class(., 'map/topicref')])" as="xs:integer"/>
  <xsl:sequence select="substring('                                                                ', 1, $ancestorCount * 3)"/>
</xsl:function>

</xsl:stylesheet>
