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
