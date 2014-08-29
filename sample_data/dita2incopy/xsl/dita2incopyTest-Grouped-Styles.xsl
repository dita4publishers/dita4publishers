<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
    <xsl:import href="plugin:org.dita4publishers.dita2indesign:xsl/dita2indesignImpl.xsl"/>
  

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 14, 2013</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p>Tests handling of grouped styles in DITA to InCopy generation</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:include href="elem2styleMapperIcml.xsl"/>
</xsl:stylesheet>