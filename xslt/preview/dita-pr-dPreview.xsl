<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Programming Domain Preview module
    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->
<xsl:template match="*[df:class(., 'pr-d/apiname')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/codeblock')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/codeph')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/coderef')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/delim')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/kwd')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/oper')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/option')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/parmname')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/sep')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/synph')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/var')]"><xsl:next-match/></xsl:template>

<xsl:template match="*[df:class(., 'pr-d/parml')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/pd')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/plentry')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/pt')]"><xsl:next-match/></xsl:template>

<xsl:template match="*[df:class(., 'pr-d/fragment')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/fragref')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/groupchoice')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/groupcomp')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/groupseq')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/repsep')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/synblk')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/synnote')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/synnoteref')]"><xsl:next-match/></xsl:template>
<xsl:template match="*[df:class(., 'pr-d/syntaxdiagram')]"><xsl:next-match/></xsl:template>

</xsl:stylesheet>
