<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:index-terms="http://dita4publishers.org/index-terms"  
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <xsl:import href="../../../toolkit_plugins/net.sf.dita4publishers.common.mapdriven/xsl/indexProcessing.xsl"/>
  
  <xsl:param name="outdir" select="./html2"/>
  <xsl:param name="CSSPATH" select="./css"/>
  <xsl:param name="topicsOutputDir" select="'topics'" as="xs:string"/>
  <xsl:param name="outext" select="'.html'"/>
  <xsl:param name="tempdir" select="./temp"/>
  <xsl:variable name="generateIndexBoolean" 
    select="true()"/>
  
  <xsl:output indent="yes"/>
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 10, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p>Test harness for testing grouping and sorting of index entries in the common map-driven XSLT code.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="/">
    <result>
      <xsl:apply-templates select="/*/index-terms:index-terms/index-terms:ungrouped" mode="group-and-sort-index"/>
    </result>
  </xsl:template>
  
  
</xsl:stylesheet>