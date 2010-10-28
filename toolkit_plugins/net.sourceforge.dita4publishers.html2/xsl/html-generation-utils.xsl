<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs htmlutil relpath"  
  version="2.0">
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/> 
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:function name="htmlutil:getTopicResultUrl" as="xs:string">
    <xsl:param name="outdir" as="xs:string"/><!-- Output directory -->
    <xsl:param name="topicDoc" as="document-node()"/>
  
    <xsl:variable name="topicHtmlFilename" 
      select="htmlutil:constructHtmlResultTopicFilename($topicDoc)" 
      as="xs:string"/>  
    
    <xsl:sequence select="relpath:newFile($outdir, $topicHtmlFilename)"/>
  </xsl:function>
  
  <xsl:function name="htmlutil:constructHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topic" as="document-node()"/>
    <xsl:variable name="topicFilename" 
      select="concat(htmlutil:getResultTopicBaseName($topic), '.html')" 
      as="xs:string"/>
    <xsl:sequence select="$topicFilename"/>    
  </xsl:function>
  
  <!--
    Construct a reliably-unique base name for result topics that can then be used to
    construct full filenames of different types.
    -->
  <xsl:function name="htmlutil:getResultTopicBaseName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="concat(relpath:getNamePart($topicUri), '_', generate-id($topicDoc))" as="xs:string"/>
    <xsl:sequence select="$baseName"/>
  </xsl:function>

  <xsl:function name="htmlutil:getXmlResultTopicFileName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="htmlutil:getResultTopicBaseName($topicDoc)" as="xs:string"/>
    <xsl:variable name="ext" select="relpath:getExtension($topicUri)"/>
    <xsl:variable name="fileName" select="concat($baseName, '.', $ext)" as="xs:string"/>
    <xsl:sequence select="$fileName"/>
  </xsl:function>
  
  <xsl:function name="htmlutil:getTopicheadHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topichead" as="element()"/>
    
    <xsl:variable name="result" select="concat('topichead_', generate-id($topichead), '.html')" as="xs:string"/>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="htmlutil:getInitialTopicrefUri" as="xs:string">
    <!-- Gets the first topic referenced by the first topicref in the list of topicrefs provided. -->
    <xsl:param name="topicRefs" as="element()*"/>
    <xsl:param name="topicsOutputPath" as="xs:string"/>
    <xsl:param name="outdir" as="xs:string"/>
    
    <xsl:variable name="initialTopicRef" select="$topicRefs[1]" as="element()?"/>
    <xsl:choose>
      <xsl:when test="$initialTopicRef">
        <xsl:variable name="initialTopic" select="df:resolveTopicRef($initialTopicRef)" as="element()?"/>
        <xsl:choose>
          <xsl:when test="$initialTopic">
            <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($topicsOutputPath, root($initialTopic))"/>
            <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
            <xsl:sequence select="$relativeUri"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="'failed-to-resolve-initial-topicref'"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'no-initial-topicref'"/>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:function>
  
</xsl:stylesheet>
