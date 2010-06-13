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
    <xsl:param name="topic" as="element()"/>
  
    <xsl:variable name="topicFilename" 
      select="concat('topic_', generate-id($topic), '.html')" 
      as="xs:string"/>  
    
    <xsl:sequence select="relpath:newFile($outdir, $topicFilename)"/>
  </xsl:function>
</xsl:stylesheet>
