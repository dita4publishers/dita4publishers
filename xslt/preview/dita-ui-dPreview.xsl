<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       User interface Domain Preview module
    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->
<xsl:template match="*[df:class(., 'ui-d/uicontrol')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'ui-d/wintitle')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'ui-d/menucascade')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'ui-d/shortcut')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'ui-d/screen')]"><xsl:next-match/></xsl:template>

</xsl:stylesheet>
