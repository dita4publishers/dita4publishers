<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs df relpath"
  version="2.0">
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-graphic-map">
    <graphic-map>
      <xsl:apply-templates select="/*//*" mode="#current"/>
    </graphic-map>
  </xsl:template>  
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-graphic-map">
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$topic//*[df:class(.,'topic/image')]" mode="#current"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/image')]" mode="generate-graphic-map">
    <xsl:variable name="docUri" select="string(document-uri(root(.)))" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="graphicPath" select="@href" as="xs:string"/>
    <xsl:variable name="rawUrl" select="concat($parentPath, '/', $graphicPath)" as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    
    <graphic-map-item
      input-url="{$absoluteUrl}"
      output-url="{relpath:newFile($imagesOutputPath, relpath:getName($absoluteUrl))}"
    />        
  </xsl:template>
  <xsl:template match="text()" mode="generate-graphic-map"/>
  
</xsl:stylesheet>
