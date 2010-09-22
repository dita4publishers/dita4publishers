<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs kindleutil relpath"  
  version="2.0">
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:function name="kindleutil:getTopicResultUrl" as="xs:string">
    <xsl:param name="outdir" as="xs:string"/><!-- Output directory -->
    <xsl:param name="topicDoc" as="document-node()"/>
  
    <xsl:variable name="topicHtmlFilename" 
      select="kindleutil:constructHtmlResultTopicFilename($topicDoc)" 
      as="xs:string"/>  
    
    <xsl:sequence select="relpath:newFile($outdir, $topicHtmlFilename)"/>
  </xsl:function>
  
  <xsl:function name="kindleutil:constructHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topic" as="document-node()"/>
    <xsl:variable name="topicFilename" 
      select="concat(kindleutil:getResultTopicBaseName($topic), '.html')" 
      as="xs:string"/>
    <xsl:sequence select="$topicFilename"/>    
  </xsl:function>
  
  <!--
    Construct a reliably-unique base name for result topics that can then be used to
    construct full filenames of different types.
    -->
  <xsl:function name="kindleutil:getResultTopicBaseName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="concat(relpath:getNamePart($topicUri), '_', generate-id($topicDoc))" as="xs:string"/>
    <xsl:sequence select="$baseName"/>
  </xsl:function>

  <xsl:function name="kindleutil:getXmlResultTopicFileName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="kindleutil:getResultTopicBaseName($topicDoc)" as="xs:string"/>
    <xsl:variable name="ext" select="relpath:getExtension($topicUri)"/>
    <xsl:variable name="fileName" select="concat($baseName, '.', $ext)" as="xs:string"/>
    <xsl:sequence select="$fileName"/>
  </xsl:function>
  
  <xsl:function name="kindleutil:getTopicheadHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topichead" as="element()"/>
    
    <xsl:variable name="result" select="concat('topichead_', generate-id($topichead), '.html')" as="xs:string"/>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="kindleutil:getKindleCoverGraphicFilename" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="sourceUri" select="kindleutil:getKindleCoverGraphicUri($context)" as="xs:string"/>
    <xsl:variable name="result" select="relpath:getName($sourceUri)" as="xs:string"/>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="kindleutil:getKindleCoverGraphicUri" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:apply-templates select="$context" mode="get-cover-graphic-path"/>
  </xsl:function>
</xsl:stylesheet>
