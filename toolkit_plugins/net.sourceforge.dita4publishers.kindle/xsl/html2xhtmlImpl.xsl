<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs xd local"
  version="2.0">
  <!-- 
    
    This module contains overrides to the corresponding module in the
    EPUB transformation type.
      -->
  
 
  <xsl:template match="body" priority="20" mode="html2xhtml">
    <body>
      <!-- For Kindle, an ID on <body> doesn't resolve, but it does on <div> -->
      <div>
        <xsl:apply-templates select="@*,node()" mode="#current"/>        
      </div>
    </body>
  </xsl:template>
  
  
  <xsl:template match="p/div" priority="10" mode="html2xhtml">
    <span>
      <xsl:apply-templates select="@*,node()" mode="#current"
      /></span>
  </xsl:template>
  
  
  
  
</xsl:stylesheet>
