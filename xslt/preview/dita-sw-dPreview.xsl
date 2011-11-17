<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Software Domain Preview module
    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->
  <xsl:template match="*[df:class(., 'sw-d/filepath')]">
    <code class="{df:getHtmlClass(.)}"><xsl:apply-templates/></code>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'sw-d/msgph')]">
    <xsl:next-match/>
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/msgblock')]">
    <xsl:next-match/>    
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/msgnum')]">
    <xsl:next-match/>
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/cmdname')]">
    <xsl:next-match/>
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/varname')]">
    <i class="{df:getHtmlClass(.)}"><xsl:apply-templates/></i>
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/userinput')]">
    <xsl:next-match/>
  </xsl:template>
  <xsl:template match="*[df:class(., 'sw-d/systemoutput')]">
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
