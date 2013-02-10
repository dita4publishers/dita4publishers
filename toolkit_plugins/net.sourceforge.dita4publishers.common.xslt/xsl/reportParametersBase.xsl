<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <!-- Default template for mode report-parameters to ensure 
       we never get to the point of calling the default template
       in this mode.
    -->
  <xsl:template match="* | text()" mode="report-parameters"/>
  
</xsl:stylesheet>