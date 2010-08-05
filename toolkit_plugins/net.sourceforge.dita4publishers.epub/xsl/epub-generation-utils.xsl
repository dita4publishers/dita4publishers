<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs epubutil relpath"  
  version="2.0">
  
  <xsl:import href="lib/relpath_util.xsl"/>
  
  <xsl:function name="epubutil:getTopicResultUrl" as="xs:string">
    <xsl:param name="outdir" as="xs:string"/><!-- Output directory -->
    <xsl:param name="topicDoc" as="document-node()"/>
  
    <xsl:variable name="topicHtmlFilename" 
      select="epubutil:constructHtmlResultTopicFilename($topicDoc)" 
      as="xs:string"/>  
    
    <xsl:sequence select="relpath:newFile($outdir, $topicHtmlFilename)"/>
  </xsl:function>
  
  <xsl:function name="epubutil:constructHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topic" as="document-node()"/>
    <xsl:variable name="topicFilename" 
      select="concat(epubutil:getResultTopicBaseName($topic), '.html')" 
      as="xs:string"/>
    <xsl:sequence select="$topicFilename"/>    
  </xsl:function>
  
  <!--
    Construct a reliably-unique base name for result topics that can then be used to
    construct full filenames of different types.
    -->
  <xsl:function name="epubutil:getResultTopicBaseName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="concat(relpath:getNamePart($topicUri), '_', generate-id($topicDoc))" as="xs:string"/>
    <xsl:sequence select="$baseName"/>
  </xsl:function>

  <xsl:function name="epubutil:getXmlResultTopicFileName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="epubutil:getResultTopicBaseName($topicDoc)" as="xs:string"/>
    <xsl:variable name="ext" select="relpath:getExtension($topicUri)"/>
    <xsl:variable name="fileName" select="concat($baseName, '.', $ext)" as="xs:string"/>
    <xsl:sequence select="$fileName"/>
  </xsl:function>
</xsl:stylesheet>
