<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       DITA for Publishers XML Domain HTML Preview
        
        
    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->
  <xsl:template match="xmlelem | *[df:class(., 'xml-d/xmlelem')]">
    <code class="{df:getHtmlClass(.)}"><xsl:text>&lt;</xsl:text><xsl:apply-templates/><xsl:text>&gt;</xsl:text></code>
  </xsl:template>
  
  <xsl:template match="xmlatt | *[df:class(., 'xml-d/xmlatt')]">
    <code class="{df:getHtmlClass(.)}"><xsl:text>@</xsl:text><xsl:apply-templates/></code>
  </xsl:template>
  
  <xsl:template match="textent | *[df:class(., 'xml-d/textent')]">
    <code class="{df:getHtmlClass(.)}"><xsl:text>&amp;</xsl:text><xsl:apply-templates/></code>
  </xsl:template>
  
  <xsl:template match="numcharref | *[df:class(., 'xml-d/numcharref')]">
    <code class="{df:getHtmlClass(.)}"><xsl:text>&amp;#x</xsl:text><xsl:apply-templates/><xsl:text>;</xsl:text></code>
  </xsl:template>
  
  
</xsl:stylesheet>
